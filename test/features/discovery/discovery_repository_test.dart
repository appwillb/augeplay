import 'package:test/test.dart';
import 'package:playauge/features/discovery/data/repositories/discovery_repository.dart';
import 'package:playauge/features/discovery/domain/models/search_filter.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';

void main() {
  late DiscoveryRepository repository;

  setUp(() {
    repository = DiscoveryRepositoryImpl();
  });

  group('DiscoveryRepository Multi-Criteria Search Tests', () {
    test('returns all profiles when no filter is provided', () async {
      const filter = SearchFilter();
      final results = await repository.searchProfiles(filter);
      expect(results.length, greaterThanOrEqualTo(5));
    });

    test('filters profiles by city', () async {
      const filter = SearchFilter(city: 'São Paulo');
      final results = await repository.searchProfiles(filter);

      expect(results.isNotEmpty, isTrue);
      for (final profile in results) {
        expect(profile.user.city, equals('São Paulo'));
      }
    });

    test('filters profiles by instrument (Bateria)', () async {
      const filter = SearchFilter(instrument: 'Bateria');
      final results = await repository.searchProfiles(filter);

      expect(results.isNotEmpty, isTrue);
      expect(results.any((p) => p.user.name.contains('Marcos')), isTrue);
    });

    test('filters profiles by role (Compositor)', () async {
      const filter = SearchFilter(role: UserRole.compositor);
      final results = await repository.searchProfiles(filter);

      expect(results.isNotEmpty, isTrue);
      expect(results.any((p) => p.user.name.contains('Ana Martins')), isTrue);
    });

    test('filters profiles by max cache range', () async {
      const filter = SearchFilter(maxCache: 700.0);
      final results = await repository.searchProfiles(filter);

      for (final profile in results) {
        if (profile.availability.baseRate != null) {
          expect(profile.availability.baseRate!, lessThanOrEqualTo(700.0));
        }
      }
    });

    test('filters profiles by availability on specific date', () async {
      final date = DateTime(2026, 10, 20);
      final filter = SearchFilter(date: date, onlyAvailable: true);
      final results = await repository.searchProfiles(filter);

      for (final profile in results) {
        expect(profile.availability.isAvailableOn(date), isTrue);
      }
    });
  });
}
