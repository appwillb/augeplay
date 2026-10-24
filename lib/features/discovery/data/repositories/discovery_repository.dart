import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/discovery/domain/models/search_filter.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';

abstract class DiscoveryRepository {
  Future<List<ProfileEntity>> searchProfiles(SearchFilter filter);
}

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final List<ProfileEntity> _profiles = List.from(MockData.profiles);

  @override
  Future<List<ProfileEntity>> searchProfiles(SearchFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _profiles.where((profile) {
      // 1. Filtro textual (nome, instrumento, bio)
      if (filter.query.isNotEmpty) {
        final q = filter.query.toLowerCase().trim();
        final nameMatch = profile.user.name.toLowerCase().contains(q) ||
            profile.user.stageName.toLowerCase().contains(q);
        final instrumentMatch =
            profile.instruments.any((i) => i.toLowerCase().contains(q));
        final cityMatch = profile.user.city.toLowerCase().contains(q);
        final genreMatch = profile.genres.any((g) => g.toLowerCase().contains(q));

        if (!nameMatch && !instrumentMatch && !cityMatch && !genreMatch) {
          return false;
        }
      }

      // 2. Filtro por papel / role
      if (filter.role != null) {
        if (!profile.user.roles.contains(filter.role)) {
          return false;
        }
      }

      // 3. Filtro por instrumento
      if (filter.instrument != null && filter.instrument!.isNotEmpty) {
        final instFilter = filter.instrument!.toLowerCase();
        final hasInstrument = profile.instruments.any(
            (i) => i.toLowerCase().contains(instFilter) || instFilter.contains(i.toLowerCase()));
        if (!hasInstrument) return false;
      }

      // 4. Filtro por cidade
      if (filter.city != null && filter.city!.isNotEmpty) {
        if (profile.user.city.toLowerCase() != filter.city!.toLowerCase().trim()) {
          return false;
        }
      }

      // 5. Filtro por estado (UF)
      if (filter.state != null && filter.state!.isNotEmpty) {
        final stateMatch = profile.user.state.toUpperCase() == filter.state!.toUpperCase();
        final servesState = profile.availability.statesServed.contains(filter.state!.toUpperCase());
        if (!stateMatch && !servesState) {
          return false;
        }
      }

      // 6. Filtro por gênero musical
      if (filter.genre != null && filter.genre!.isNotEmpty) {
        final gFilter = filter.genre!.toLowerCase();
        if (!profile.genres.any((g) => g.toLowerCase().contains(gFilter))) {
          return false;
        }
      }

      // 7. Filtro por somente disponíveis
      if (filter.onlyAvailable) {
        if (!profile.availability.isAvailable) return false;
      }

      // 8. Filtro por data de disponibilidade
      if (filter.date != null) {
        if (!profile.availability.isAvailableOn(filter.date!)) {
          return false;
        }
      }

      // 9. Faixa de cachê
      if (filter.minCache != null && profile.availability.baseRate != null) {
        if (profile.availability.baseRate! < filter.minCache!) return false;
      }
      if (filter.maxCache != null && profile.availability.baseRate != null) {
        if (profile.availability.baseRate! > filter.maxCache!) return false;
      }

      // 10. Avaliação mínima
      if (filter.minRating > 0.0) {
        if (profile.user.rating < filter.minRating) return false;
      }

      return true;
    }).toList();
  }
}
