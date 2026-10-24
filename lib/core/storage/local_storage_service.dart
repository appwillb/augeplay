import 'dart:convert';
import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'local_storage_stub.dart' if (dart.library.html) 'local_storage_web.dart';

class LocalStorageService {
  static const String _keyCurrentUser = 'playauge_current_user';
  static const String _keyProfiles = 'playauge_profiles';
  static const String _keyAuthStatus = 'playauge_is_logged_in';

  // --- Auth Session ---
  static void saveCurrentUser(UserEntity? user) {
    if (user == null) {
      LocalStoragePlatform.remove(_keyCurrentUser);
      LocalStoragePlatform.setString(_keyAuthStatus, 'false');
    } else {
      LocalStoragePlatform.setString(_keyCurrentUser, jsonEncode(user.toJson()));
      LocalStoragePlatform.setString(_keyAuthStatus, 'true');
    }
  }

  static UserEntity? loadCurrentUser() {
    final raw = LocalStoragePlatform.getString(_keyCurrentUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserEntity.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static bool? loadAuthStatus() {
    final raw = LocalStoragePlatform.getString(_keyAuthStatus);
    if (raw == 'false') return false;
    if (raw == 'true') return true;
    return null;
  }

  // --- Profiles & Cache ---
  static void saveProfiles(List<ProfileEntity> profiles) {
    try {
      final list = profiles.map((p) => p.toJson()).toList();
      LocalStoragePlatform.setString(_keyProfiles, jsonEncode(list));
    } catch (_) {}
  }

  static List<ProfileEntity>? loadProfiles() {
    final raw = LocalStoragePlatform.getString(_keyProfiles);
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => ProfileEntity.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  static void saveProfile(ProfileEntity profile) {
    final current = loadProfiles() ?? List.from(MockData.profiles);
    final idx = current.indexWhere((p) => p.user.id == profile.user.id);
    if (idx != -1) {
      current[idx] = profile;
    } else {
      current.add(profile);
    }
    saveProfiles(current);
  }
}
