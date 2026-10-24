import 'package:test/test.dart';
import 'package:playauge/features/opportunities/data/repositories/opportunity_repository.dart';
import 'package:playauge/features/opportunities/domain/models/opportunity_entity.dart';

void main() {
  late OpportunityRepository repository;

  setUp(() {
    repository = OpportunityRepositoryImpl();
  });

  group('OpportunityRepository Tests', () {
    test('fetches initial opportunities list', () async {
      final list = await repository.getOpportunities();
      expect(list.isNotEmpty, isTrue);
      expect(list.any((o) => o.title.contains('Baterista')), isTrue);
    });

    test('creates new opportunity', () async {
      final newOp = OpportunityEntity(
        id: 'new_op_1',
        title: 'Vaga Urgente para Baixista',
        creatorId: 'user_test',
        creatorName: 'Produtor Teste',
        type: OpportunityType.show,
        instrumentNeeded: 'Baixo',
        city: 'Campinas',
        state: 'SP',
        eventDate: DateTime(2026, 11, 1),
        genre: 'Rock',
        cacheAmount: 500.0,
        description: 'Show acústico no pub.',
        createdAt: DateTime.now(),
      );

      final created = await repository.createOpportunity(newOp);
      expect(created.id, equals('new_op_1'));

      final all = await repository.getOpportunities();
      expect(all.first.title, equals('Vaga Urgente para Baixista'));
    });

    test('applies to opportunity and increments applicants', () async {
      final all = await repository.getOpportunities();
      final targetId = all.first.id;

      await repository.applyToOpportunity(targetId, 'user_applicant_123');

      final updated = await repository.getOpportunityById(targetId);
      expect(updated?.interestedUserIds, contains('user_applicant_123'));
    });
  });
}
