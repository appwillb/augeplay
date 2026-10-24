/// Status e Configuração de Disponibilidade Profissional
class AvailabilityEntity {
  final bool isAvailable; // 🟢 Disponível vs ⚪ Indisponível
  final double? baseRate;  // Cachê base / diária sugerida
  final int serviceRadiusKm; // Raio de atendimento
  final List<String> statesServed; // Estados onde aceita viajar/trabalhar
  final List<DateTime> specificAvailableDates; // Dias confirmados disponíveis
  final List<DateTime> blockedDates; // Dias indisponíveis / ocupados
  final String? notes; // Condições (Ex: "Tenho equipamento próprio")

  const AvailabilityEntity({
    this.isAvailable = true,
    this.baseRate,
    this.serviceRadiusKm = 100,
    this.statesServed = const [],
    this.specificAvailableDates = const [],
    this.blockedDates = const [],
    this.notes,
  });

  /// Verifica se o profissional está disponível em uma data específica
  bool isAvailableOn(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final isBlocked = blockedDates.any((d) =>
        d.year == normalizedDate.year &&
        d.month == normalizedDate.month &&
        d.day == normalizedDate.day);
    if (isBlocked) return false;

    if (!isAvailable) {
      // Se está globalmente indisponível, verifica se abriu exceção para esta data específica
      return specificAvailableDates.any((d) =>
          d.year == normalizedDate.year &&
          d.month == normalizedDate.month &&
          d.day == normalizedDate.day);
    }

    return true;
  }

  AvailabilityEntity copyWith({
    bool? isAvailable,
    double? baseRate,
    int? serviceRadiusKm,
    List<String>? statesServed,
    List<DateTime>? specificAvailableDates,
    List<DateTime>? blockedDates,
    String? notes,
  }) {
    return AvailabilityEntity(
      isAvailable: isAvailable ?? this.isAvailable,
      baseRate: baseRate ?? this.baseRate,
      serviceRadiusKm: serviceRadiusKm ?? this.serviceRadiusKm,
      statesServed: statesServed ?? this.statesServed,
      specificAvailableDates: specificAvailableDates ?? this.specificAvailableDates,
      blockedDates: blockedDates ?? this.blockedDates,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'baseRate': baseRate,
      'serviceRadiusKm': serviceRadiusKm,
      'statesServed': statesServed,
      'specificAvailableDates': specificAvailableDates.map((d) => d.toIso8601String()).toList(),
      'blockedDates': blockedDates.map((d) => d.toIso8601String()).toList(),
      'notes': notes,
    };
  }

  factory AvailabilityEntity.fromJson(Map<String, dynamic> json) {
    return AvailabilityEntity(
      isAvailable: json['isAvailable'] as bool? ?? true,
      baseRate: (json['baseRate'] as num?)?.toDouble(),
      serviceRadiusKm: json['serviceRadiusKm'] as int? ?? 100,
      statesServed: (json['statesServed'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      specificAvailableDates: (json['specificAvailableDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e.toString()))
              .toList() ??
          [],
      blockedDates: (json['blockedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e.toString()))
              .toList() ??
          [],
      notes: json['notes'] as String?,
    );
  }
}
