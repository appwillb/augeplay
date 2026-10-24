import 'package:flutter/foundation.dart';
import 'package:playauge/features/discovery/data/repositories/discovery_repository.dart';
import 'package:playauge/features/discovery/domain/models/search_filter.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';

class DiscoveryProvider extends ChangeNotifier {
  final DiscoveryRepository _repository;

  SearchFilter _filter = const SearchFilter();
  List<ProfileEntity> _profiles = [];
  bool _isLoading = false;

  DiscoveryProvider(this._repository) {
    search();
  }

  SearchFilter get filter => _filter;
  List<ProfileEntity> get profiles => List.unmodifiable(_profiles);
  bool get isLoading => _isLoading;

  Future<void> search() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profiles = await _repository.searchProfiles(_filter);
    } catch (_) {
      _profiles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilter(SearchFilter newFilter) {
    _filter = newFilter;
    search();
  }

  void updateQuery(String query) {
    _filter = _filter.copyWith(query: query);
    search();
  }

  void updateCity(String? city) {
    if (city == null || city.isEmpty) {
      _filter = _filter.copyWith(clearCity: true);
    } else {
      _filter = _filter.copyWith(city: city);
    }
    search();
  }

  void updateInstrument(String? instrument) {
    if (instrument == null || instrument.isEmpty) {
      _filter = _filter.copyWith(clearInstrument: true);
    } else {
      _filter = _filter.copyWith(instrument: instrument);
    }
    search();
  }

  void toggleOnlyAvailable(bool onlyAvailable) {
    _filter = _filter.copyWith(onlyAvailable: onlyAvailable);
    search();
  }

  void clearFilters() {
    _filter = const SearchFilter();
    search();
  }
}
