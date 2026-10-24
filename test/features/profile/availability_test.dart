import 'package:test/test.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';

void main() {
  group('AvailabilityEntity Tests', () {
    test('isAvailableOn respects global availability when no blocks', () {
      const avail = AvailabilityEntity(isAvailable: true);
      final checkDate = DateTime(2026, 10, 20);
      expect(avail.isAvailableOn(checkDate), isTrue);

      const unavail = AvailabilityEntity(isAvailable: false);
      expect(unavail.isAvailableOn(checkDate), isFalse);
    });

    test('isAvailableOn correctly flags blocked dates', () {
      final blocked = DateTime(2026, 10, 22);
      final avail = AvailabilityEntity(
        isAvailable: true,
        blockedDates: [blocked],
      );

      expect(avail.isAvailableOn(DateTime(2026, 10, 21)), isTrue);
      expect(avail.isAvailableOn(DateTime(2026, 10, 22)), isFalse);
    });

    test('isAvailableOn allows specific dates when globally unavailable', () {
      final exceptionDate = DateTime(2026, 10, 25);
      final avail = AvailabilityEntity(
        isAvailable: false,
        specificAvailableDates: [exceptionDate],
      );

      expect(avail.isAvailableOn(DateTime(2026, 10, 24)), isFalse);
      expect(avail.isAvailableOn(DateTime(2026, 10, 25)), isTrue);
    });

    test('AvailabilityEntity JSON serialization', () {
      final avail = AvailabilityEntity(
        isAvailable: true,
        baseRate: 750.0,
        serviceRadiusKm: 300,
        statesServed: const ['SP', 'MG'],
        notes: 'Equipamento completo',
      );

      final json = avail.toJson();
      expect(json['isAvailable'], isTrue);
      expect(json['baseRate'], equals(750.0));
      expect(json['serviceRadiusKm'], equals(300));
      expect(json['statesServed'], contains('SP'));

      final fromJson = AvailabilityEntity.fromJson(json);
      expect(fromJson.isAvailable, isTrue);
      expect(fromJson.baseRate, equals(750.0));
      expect(fromJson.serviceRadiusKm, equals(300));
      expect(fromJson.notes, equals('Equipamento completo'));
    });
  });
}
