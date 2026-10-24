import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';

abstract class ProfileRepository {
  Future<List<ProfileEntity>> getAllProfiles();
  Future<ProfileEntity?> getProfileByUserId(String userId);
  Future<ProfileEntity> updateAvailability(String userId, AvailabilityEntity availability);
  Future<ProfileEntity> updateProfile(ProfileEntity profile);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final List<ProfileEntity> _profiles = List.from(MockData.profiles);

  @override
  Future<List<ProfileEntity>> getAllProfiles() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_profiles);
  }

  @override
  Future<ProfileEntity?> getProfileByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _profiles.firstWhere((p) => p.user.id == userId);
    } catch (_) {
      try {
        final mock = MockData.profiles.firstWhere((p) => p.user.id == userId);
        _profiles.add(mock);
        return mock;
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<ProfileEntity> updateAvailability(String userId, AvailabilityEntity availability) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _profiles.indexWhere((p) => p.user.id == userId);
    if (index != -1) {
      final updated = _profiles[index].copyWith(availability: availability);
      _profiles[index] = updated;
      return updated;
    }
    final fallback = MockData.profiles.firstWhere(
      (p) => p.user.id == userId,
      orElse: () => ProfileEntity(
        user: MockData.allUsers.firstWhere(
          (u) => u.id == userId,
          orElse: () => MockData.joaoSilva,
        ),
      ),
    );
    final updated = fallback.copyWith(availability: availability);
    _profiles.add(updated);
    return updated;
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _profiles.indexWhere((p) => p.user.id == profile.user.id);
    if (index != -1) {
      _profiles[index] = profile;
      return profile;
    } else {
      _profiles.add(profile);
      return profile;
    }
  }
}
