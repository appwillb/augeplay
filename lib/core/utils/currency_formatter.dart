/// Formatador de Moeda para Cachês e Valores Profissionais em BRL (Zero dependências externas)
class CurrencyFormatter {
  /// Ex: 650.0 -> "R$ 650,00"
  static String formatBRL(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Formatação de milhar brasileira
    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    final formattedInt = buffer.toString().split('').reversed.join('');

    return 'R\$ $formattedInt,$decimalPart';
  }

  /// Ex: 1500.0 -> "R$ 1,5 mil"
  static String formatCompact(double amount) {
    if (amount >= 1000) {
      final thousands = (amount / 1000).toStringAsFixed(1).replaceAll('.0', '');
      return 'R\$ $thousands mil';
    }
    return formatBRL(amount);
  }

  /// Exibe faixa de cachê ou "Cachê a combinar"
  static String formatCacheRange(double? min, double? max) {
    if (min == null && max == null) return 'Cachê a combinar';
    if (min != null && max == null) return 'A partir de ${formatBRL(min)}';
    if (min == null && max != null) return 'Até ${formatBRL(max)}';
    if (min == max) return formatBRL(min!);
    return '${formatBRL(min!)} - ${formatBRL(max!)}';
  }
}
