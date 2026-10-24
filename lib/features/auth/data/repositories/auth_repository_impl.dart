import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/core/errors/failures.dart';
import 'package:playauge/core/storage/local_storage_service.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';
import 'package:playauge/features/auth/domain/repositories/auth_repository.dart';

/// Implementação do Repositório de Autenticação
/// Com persistência automática em LocalStorage (sessão mantida após F5 / restart)
class AuthRepositoryImpl implements AuthRepository {
  UserEntity? _currentUser;

  AuthRepositoryImpl() {
    final savedAuth = LocalStorageService.loadAuthStatus();
    final savedUser = LocalStorageService.loadCurrentUser();

    if (savedAuth == false) {
      _currentUser = null;
    } else if (savedUser != null) {
      _currentUser = savedUser;
    } else {
      _currentUser = MockData.joaoSilva;
      LocalStorageService.saveCurrentUser(_currentUser);
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (password.length < 6) {
      throw const AuthFailure('A senha deve conter pelo menos 6 caracteres.');
    }

    final savedProfiles = LocalStorageService.loadProfiles();
    UserEntity? foundInSaved;
    if (savedProfiles != null) {
      for (final p in savedProfiles) {
        if (p.user.email.toLowerCase() == email.trim().toLowerCase()) {
          foundInSaved = p.user;
          break;
        }
      }
    }

    final found = foundInSaved ?? MockData.allUsers.firstWhere(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      orElse: () => UserEntity(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        stageName: email.split('@').first,
        email: email.trim(),
        city: 'São Paulo',
        state: 'SP',
        bio: 'Músico cadastrado no PlayAuge.',
        roles: const [UserRole.musico],
      ),
    );

    _currentUser = found;
    LocalStorageService.saveCurrentUser(found);
    return found;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String stageName,
    required String email,
    required String password,
    required String city,
    required String state,
    required String bio,
    required List<UserRole> roles,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newUser = UserEntity(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      stageName: stageName.isNotEmpty ? stageName : name,
      email: email.trim(),
      city: city,
      state: state,
      bio: bio,
      roles: roles.isNotEmpty ? roles : const [UserRole.musico],
    );

    _currentUser = newUser;
    LocalStorageService.saveCurrentUser(newUser);
    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
    LocalStorageService.saveCurrentUser(null);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<UserEntity> updateCurrentUser(UserEntity user) async {
    _currentUser = user;
    LocalStorageService.saveCurrentUser(user);
    return user;
  }
}
