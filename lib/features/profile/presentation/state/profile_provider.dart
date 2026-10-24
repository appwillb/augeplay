import 'package:flutter/foundation.dart';
import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/core/storage/local_storage_service.dart';
import 'package:playauge/features/profile/data/repositories/profile_repository.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  final Map<String, ProfileEntity> _profileCache = {};
  ProfileEntity? _selectedProfile;
  bool _isLoading = false;

  ProfileProvider(this._repository) {
    _initFromStorage();
  }

  void _initFromStorage() {
    final saved = LocalStorageService.loadProfiles();
    if (saved != null && saved.isNotEmpty) {
      for (final p in saved) {
        _profileCache[p.user.id] = p;
      }
    } else {
      for (final p in MockData.profiles) {
        _profileCache[p.user.id] = p;
      }
      LocalStorageService.saveProfiles(MockData.profiles);
    }
  }

  ProfileEntity? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;

  ProfileEntity? getProfile(String userId) {
    if (_profileCache.containsKey(userId)) {
      return _profileCache[userId];
    }
    final saved = LocalStorageService.loadProfiles();
    if (saved != null) {
      final found = saved.where((p) => p.user.id == userId).firstOrNull;
      if (found != null) {
        _profileCache[userId] = found;
        return found;
      }
    }
    final mock = MockData.profiles.where((p) => p.user.id == userId).firstOrNull;
    if (mock != null) {
      _profileCache[userId] = mock;
      return mock;
    }
    return _selectedProfile?.user.id == userId ? _selectedProfile : null;
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final profile = await _repository.getProfileByUserId(userId);
      if (profile != null) {
        _profileCache[userId] = profile;
        _selectedProfile = profile;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProfile(ProfileEntity profile) {
    _selectedProfile = profile;
    _profileCache[profile.user.id] = profile;
    notifyListeners();
  }

  Future<void> updateAvatarUrl(String newAvatarUrl, {String? userId}) async {
    final targetId = userId ?? _selectedProfile?.user.id;
    final current = (targetId != null ? getProfile(targetId) : null) ?? _selectedProfile;
    if (current == null) return;

    final updatedUser = current.user.copyWith(avatarUrl: newAvatarUrl);
    final updatedProfile = current.copyWith(user: updatedUser);
    await updateProfile(updatedProfile);
  }

  Future<ProfileEntity?> updateAvailability(AvailabilityEntity availability, {String? userId}) async {
    final targetId = userId ?? _selectedProfile?.user.id;
    if (targetId == null) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.updateAvailability(targetId, availability);
      _profileCache[targetId] = updated;
      if (_selectedProfile?.user.id == targetId) {
        _selectedProfile = updated;
      }
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.updateProfile(profile);
      _profileCache[profile.user.id] = updated;
      if (_selectedProfile?.user.id == profile.user.id) {
        _selectedProfile = updated;
      }
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
