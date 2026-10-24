import 'package:flutter_test/flutter_test.dart';
import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/features/profile/data/repositories/profile_repository.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';

void main() {
  group('Profile & Auth Functional Tests (Logout, Profile Edit, Cache Save)', () {
    late ProfileRepositoryImpl profileRepo;
    late ProfileProvider profileProvider;
    late AuthRepositoryImpl authRepo;
    late AuthProvider authProvider;

    setUp(() {
      profileRepo = ProfileRepositoryImpl();
      profileProvider = ProfileProvider(profileRepo);
      authRepo = AuthRepositoryImpl();
      authProvider = AuthProvider(authRepo);
    });

    test('updateAvailability correctly saves base rate and updates profile cache', () async {
      final initialProfile = MockData.profiles.first;
      profileProvider.selectProfile(initialProfile);

      const newAvailability = AvailabilityEntity(
        isAvailable: true,
        baseRate: 1500.0,
        serviceRadiusKm: 250,
        notes: 'Equipamento valvulado incluso.',
      );

      final updated = await profileProvider.updateAvailability(
        newAvailability,
        userId: initialProfile.user.id,
      );

      expect(updated, isNotNull);
      expect(updated!.availability.baseRate, 1500.0);
      expect(updated.availability.serviceRadiusKm, 250);
      expect(updated.availability.notes, 'Equipamento valvulado incluso.');

      final cached = profileProvider.getProfile(initialProfile.user.id);
      expect(cached?.availability.baseRate, 1500.0);
      expect(profileProvider.selectedProfile?.availability.baseRate, 1500.0);
    });

    test('updateProfile correctly saves name, bio, city and instruments', () async {
      final initialProfile = MockData.profiles.first;
      profileProvider.selectProfile(initialProfile);

      final updatedUser = initialProfile.user.copyWith(
        name: 'João Silva Editado',
        stageName: 'João da Guitarra',
        bio: 'Guitarrista e produtor premiado.',
        city: 'Belo Horizonte',
        state: 'MG',
      );

      final updatedProfile = initialProfile.copyWith(
        user: updatedUser,
        instruments: ['Guitarra Solo', 'Violão 7 Cordas', 'Vocal'],
        genres: ['Rock', 'Sertanejo', 'Blues'],
        yearsOfExperience: 18,
      );

      final result = await profileProvider.updateProfile(updatedProfile);

      expect(result.user.name, 'João Silva Editado');
      expect(result.user.stageName, 'João da Guitarra');
      expect(result.user.displayName, 'João da Guitarra');
      expect(result.user.city, 'Belo Horizonte');
      expect(result.user.state, 'MG');
      expect(result.yearsOfExperience, 18);
      expect(result.instruments, contains('Violão 7 Cordas'));

      final cached = profileProvider.getProfile(initialProfile.user.id);
      expect(cached?.user.name, 'João Silva Editado');
    });

    test('AuthProvider logout clears current user and triggers unauthenticated state', () async {
      // Começa autenticado
      expect(authProvider.currentUser, isNotNull);
      expect(authProvider.isAuthenticated, isTrue);

      // Executa logout
      await authProvider.logout();

      expect(authProvider.currentUser, isNull);
      expect(authProvider.isAuthenticated, isFalse);

      // Pode logar novamente com credenciais
      final loginSuccess = await authProvider.login('joao.silva@playauge.demo', '123456');
      expect(loginSuccess, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.currentUser?.email, 'joao.silva@playauge.demo');
    });
  });
}
