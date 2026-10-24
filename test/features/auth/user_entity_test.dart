import 'package:test/test.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';

void main() {
  group('UserEntity & UserRole Tests', () {
    test('UserRole labels and string parsing', () {
      expect(UserRole.artista.shortLabel, equals('Artista'));
      expect(UserRole.musico.shortLabel, equals('Músico'));
      expect(UserRole.compositor.shortLabel, equals('Compositor'));

      expect(UserRole.fromString('artista'), equals(UserRole.artista));
      expect(UserRole.fromString('Musico'), equals(UserRole.musico));
      expect(UserRole.fromString('unknown'), equals(UserRole.musico));
    });

    test('UserEntity serialization and deserialization', () {
      const user = UserEntity(
        id: 'user_123',
        name: 'Carlos Silva',
        stageName: 'Carlinhos Batera',
        email: 'carlos@playauge.com',
        city: 'Goiânia',
        state: 'GO',
        bio: 'Baterista profissional',
        roles: [UserRole.musico, UserRole.produtor],
        rating: 4.8,
        ratingsCount: 15,
        followersCount: 500,
        followingCount: 120,
      );

      final json = user.toJson();
      expect(json['id'], equals('user_123'));
      expect(json['stageName'], equals('Carlinhos Batera'));
      expect(json['roles'], contains('musico'));
      expect(json['roles'], contains('produtor'));

      final fromJson = UserEntity.fromJson(json);
      expect(fromJson.id, equals(user.id));
      expect(fromJson.name, equals(user.name));
      expect(fromJson.displayName, equals('Carlinhos Batera'));
      expect(fromJson.locationFormatted, equals('Goiânia - GO'));
      expect(fromJson.roles.length, equals(2));
      expect(fromJson.roles, contains(UserRole.musico));
    });

    test('UserEntity copyWith modifies specific fields', () {
      const user = UserEntity(
        id: 'u1',
        name: 'Pedro',
        stageName: 'Pedro Guitar',
        email: 'pedro@email.com',
        city: 'São Paulo',
        state: 'SP',
        bio: 'Guitarrista',
        roles: [UserRole.musico],
      );

      final updated = user.copyWith(city: 'Campinas', rating: 4.9);
      expect(updated.city, equals('Campinas'));
      expect(updated.rating, equals(4.9));
      expect(updated.name, equals('Pedro'));
      expect(updated.state, equals('SP'));
    });
  });
}
