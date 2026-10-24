import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';

/// Contrato da Camada de Domínio para Autenticação
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register({
    required String name,
    required String stageName,
    required String email,
    required String password,
    required String city,
    required String state,
    required String bio,
    required List<UserRole> roles,
  });
  Future<void> logout();
  Future<void> sendPasswordReset(String email);
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> updateCurrentUser(UserEntity user);
}
