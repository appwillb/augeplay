import 'package:flutter/foundation.dart';
import 'package:playauge/features/opportunities/data/repositories/opportunity_repository.dart';
import 'package:playauge/features/opportunities/domain/models/opportunity_entity.dart';

class OpportunityProvider extends ChangeNotifier {
  final OpportunityRepository _repository;

  List<OpportunityEntity> _opportunities = [];
  bool _isLoading = false;

  OpportunityProvider(this._repository) {
    loadOpportunities();
  }

  List<OpportunityEntity> get opportunities => List.unmodifiable(_opportunities);
  bool get isLoading => _isLoading;

  Future<void> loadOpportunities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _opportunities = await _repository.getOpportunities();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyToOpportunity(String opportunityId, String userId) async {
    await _repository.applyToOpportunity(opportunityId, userId);
    await loadOpportunities();
  }

  Future<void> createOpportunity(OpportunityEntity opp) async {
    await _repository.createOpportunity(opp);
    await loadOpportunities();
  }
}
