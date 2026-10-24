import 'package:test/test.dart';
import 'package:playauge/features/discovery/domain/models/search_filter.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';

void main() {
  group('SearchFilter Tests', () {
    test('hasActiveFilters detects changes correctly', () {
      const defaultFilter = SearchFilter();
      expect(defaultFilter.hasActiveFilters, isFalse);

      final withQuery = defaultFilter.copyWith(query: 'Baterista');
      expect(withQuery.hasActiveFilters, isTrue);

      final withRole = defaultFilter.copyWith(role: UserRole.musico);
      expect(withRole.hasActiveFilters, isTrue);

      final withAvailability = defaultFilter.copyWith(onlyAvailable: true);
      expect(withAvailability.hasActiveFilters, isTrue);

      final withRating = defaultFilter.copyWith(minRating: 4.5);
      expect(withRating.hasActiveFilters, isTrue);
    });

    test('copyWith clear flags reset individual filter fields', () {
      final initial = SearchFilter(
        role: UserRole.musico,
        city: 'São Paulo',
        state: 'SP',
        instrument: 'Guitarra',
      );

      final cleared = initial.copyWith(clearCity: true, clearInstrument: true);
      expect(cleared.city, isNull);
      expect(cleared.instrument, isNull);
      expect(cleared.state, equals('SP'));
      expect(cleared.role, equals(UserRole.musico));
    });
  });
}
