import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/opportunities/domain/models/opportunity_entity.dart';

abstract class OpportunityRepository {
  Future<List<OpportunityEntity>> getOpportunities();
  Future<OpportunityEntity?> getOpportunityById(String id);
  Future<OpportunityEntity> createOpportunity(OpportunityEntity opportunity);
  Future<void> applyToOpportunity(String opportunityId, String userId);
  Future<void> closeOpportunity(String opportunityId);
}

class OpportunityRepositoryImpl implements OpportunityRepository {
  final List<OpportunityEntity> _opportunities = List.from(MockData.opportunities);

  @override
  Future<List<OpportunityEntity>> getOpportunities() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_opportunities);
  }

  @override
  Future<OpportunityEntity?> getOpportunityById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _opportunities.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<OpportunityEntity> createOpportunity(OpportunityEntity opportunity) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _opportunities.insert(0, opportunity);
    return opportunity;
  }

  @override
  Future<void> applyToOpportunity(String opportunityId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _opportunities.indexWhere((o) => o.id == opportunityId);
    if (index != -1) {
      final opp = _opportunities[index];
      if (!opp.interestedUserIds.contains(userId)) {
        final updatedList = List<String>.from(opp.interestedUserIds)..add(userId);
        _opportunities[index] = opp.copyWith(interestedUserIds: updatedList);
      }
    }
  }

  @override
  Future<void> closeOpportunity(String opportunityId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _opportunities.indexWhere((o) => o.id == opportunityId);
    if (index != -1) {
      _opportunities[index] = _opportunities[index].copyWith(isOpen: false);
    }
  }
}
