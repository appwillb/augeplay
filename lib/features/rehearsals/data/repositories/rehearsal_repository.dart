import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/rehearsals/domain/models/rehearsal_entity.dart';

abstract class RehearsalRepository {
  Future<List<RehearsalEntity>> getRehearsals();
  Future<RehearsalEntity> createRehearsal(RehearsalEntity rehearsal);
  Future<RehearsalEntity> addRepertoireItem(String rehearsalId, RepertoireItem item);
  Future<RehearsalEntity> confirmPresence(String rehearsalId, String participantName);
}

class RehearsalRepositoryImpl implements RehearsalRepository {
  final List<RehearsalEntity> _rehearsals = List.from(MockData.rehearsals);

  @override
  Future<List<RehearsalEntity>> getRehearsals() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_rehearsals);
  }

  @override
  Future<RehearsalEntity> createRehearsal(RehearsalEntity rehearsal) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _rehearsals.insert(0, rehearsal);
    return rehearsal;
  }

  @override
  Future<RehearsalEntity> addRepertoireItem(String rehearsalId, RepertoireItem item) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _rehearsals.indexWhere((r) => r.id == rehearsalId);
    if (index != -1) {
      final r = _rehearsals[index];
      final updatedRep = List<RepertoireItem>.from(r.repertoire)..add(item);
      final updated = r.copyWith(repertoire: updatedRep);
      _rehearsals[index] = updated;
      return updated;
    }
    throw Exception('Ensaio não encontrado');
  }

  @override
  Future<RehearsalEntity> confirmPresence(String rehearsalId, String participantName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _rehearsals.indexWhere((r) => r.id == rehearsalId);
    if (index != -1) {
      final r = _rehearsals[index];
      if (!r.confirmedParticipantNames.contains(participantName)) {
        final updatedList = List<String>.from(r.confirmedParticipantNames)..add(participantName);
        final updated = r.copyWith(confirmedParticipantNames: updatedList);
        _rehearsals[index] = updated;
        return updated;
      }
      return r;
    }
    throw Exception('Ensaio não encontrado');
  }
}
