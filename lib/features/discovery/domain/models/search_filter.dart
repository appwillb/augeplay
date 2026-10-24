import 'package:playauge/features/auth/domain/models/user_role.dart';

/// Modelo de Filtros para Descoberta de Profissionais e Oportunidades
class SearchFilter {
  final String query;
  final UserRole? role;
  final String? instrument;
  final String? city;
  final String? state;
  final DateTime? date;
  final String? genre;
  final bool onlyAvailable;
  final double? minCache;
  final double? maxCache;
  final double minRating;

  const SearchFilter({
    this.query = '',
    this.role,
    this.instrument,
    this.city,
    this.state,
    this.date,
    this.genre,
    this.onlyAvailable = false,
    this.minCache,
    this.maxCache,
    this.minRating = 0.0,
  });

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      role != null ||
      instrument != null ||
      city != null ||
      state != null ||
      date != null ||
      genre != null ||
      onlyAvailable ||
      minCache != null ||
      maxCache != null ||
      minRating > 0.0;

  SearchFilter copyWith({
    String? query,
    UserRole? role,
    String? instrument,
    String? city,
    String? state,
    DateTime? date,
    String? genre,
    bool? onlyAvailable,
    double? minCache,
    double? maxCache,
    double? minRating,
    bool clearRole = false,
    bool clearInstrument = false,
    bool clearCity = false,
    bool clearState = false,
    bool clearDate = false,
    bool clearGenre = false,
  }) {
    return SearchFilter(
      query: query ?? this.query,
      role: clearRole ? null : (role ?? this.role),
      instrument: clearInstrument ? null : (instrument ?? this.instrument),
      city: clearCity ? null : (city ?? this.city),
      state: clearState ? null : (state ?? this.state),
      date: clearDate ? null : (date ?? this.date),
      genre: clearGenre ? null : (genre ?? this.genre),
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      minCache: minCache ?? this.minCache,
      maxCache: maxCache ?? this.maxCache,
      minRating: minRating ?? this.minRating,
    );
  }
}
