import 'package:flutter/foundation.dart';
import 'package:playauge/features/profile/data/repositories/profile_repository.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileEntity? _selectedProfile;
  bool _isLoading = false;

  ProfileProvider(this._repository);

  ProfileEntity? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedProfile = await _repository.getProfileByUserId(userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProfile(ProfileEntity profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  Future<void> updateAvailability(AvailabilityEntity availability) async {
    if (_selectedProfile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.updateAvailability(_selectedProfile!.user.id, availability);
      _selectedProfile = updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
