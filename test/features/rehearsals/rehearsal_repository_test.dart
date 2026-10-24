import 'package:test/test.dart';
import 'package:playauge/features/rehearsals/data/repositories/rehearsal_repository.dart';
import 'package:playauge/features/rehearsals/domain/models/rehearsal_entity.dart';

void main() {
  late RehearsalRepository repository;

  setUp(() {
    repository = RehearsalRepositoryImpl();
  });

  group('RehearsalRepository Tests', () {
    test('fetches rehearsals and verifies repertoire', () async {
      final list = await repository.getRehearsals();
      expect(list.isNotEmpty, isTrue);
      expect(list.first.repertoire.isNotEmpty, isTrue);
      expect(list.first.repertoire.first.songTitle, equals('Estrada do Destino'));
    });

    test('adds song to rehearsal repertoire', () async {
      const newItem = RepertoireItem(
        id: 'rep_new',
        songTitle: 'Fio de Cabelo',
        musicalKey: 'A Maior',
        bpm: 104,
        notes: 'Entrada com violão de 12 cordas',
      );

      final updated = await repository.addRepertoireItem('reh_1', newItem);
      expect(updated.repertoire.any((r) => r.songTitle == 'Fio de Cabelo'), isTrue);
    });

    test('confirms presence of participant in rehearsal', () async {
      final updated = await repository.confirmPresence('reh_1', 'Marcos Oliveira');
      expect(updated.confirmedParticipantNames, contains('Marcos Oliveira'));
    });
  });
}
