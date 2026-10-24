import 'package:test/test.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/core/utils/date_formatter.dart';
import 'package:playauge/core/utils/validators.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('formatBRL formats monetary value properly', () {
      final formatted = CurrencyFormatter.formatBRL(650.0);
      expect(formatted, contains('650'));
      expect(formatted, contains('R\$'));
    });

    test('formatCacheRange handles nulls and bounds', () {
      expect(CurrencyFormatter.formatCacheRange(null, null), equals('Cachê a combinar'));
      expect(CurrencyFormatter.formatCacheRange(500, null), contains('A partir de'));
      expect(CurrencyFormatter.formatCacheRange(null, 1000), contains('Até'));
      expect(CurrencyFormatter.formatCacheRange(500, 500), contains('500'));
      expect(CurrencyFormatter.formatCacheRange(500, 1000), contains('-'));
    });
  });

  group('DateFormatter Tests', () {
    test('formatDate outputs dd/MM/yyyy', () {
      final date = DateTime(2026, 10, 20);
      expect(DateFormatter.formatDate(date), equals('20/10/2026'));
    });

    test('formatTime outputs HH:mm', () {
      final date = DateTime(2026, 10, 20, 19, 30);
      expect(DateFormatter.formatTime(date), equals('19:30'));
    });
  });

  group('Validators Tests', () {
    test('validateEmail validates correctly', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('musico@playauge.com'), isNull);
    });

    test('validatePassword requires at least 6 characters', () {
      expect(Validators.validatePassword('123'), isNotNull);
      expect(Validators.validatePassword('123456'), isNull);
    });

    test('validateRequired validates non-empty strings', () {
      expect(Validators.validateRequired('', 'Nome'), isNotNull);
      expect(Validators.validateRequired('   ', 'Nome'), isNotNull);
      expect(Validators.validateRequired('João', 'Nome'), isNull);
    });
  });
}
