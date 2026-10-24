import 'package:test/test.dart';
import 'package:playauge/features/contracts/data/repositories/contract_repository.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';

void main() {
  late ContractRepository repository;

  setUp(() {
    repository = ContractRepositoryImpl();
  });

  group('ContractRepository Tests', () {
    test('gets invites for specific user', () async {
      final list = await repository.getInvitesForUser('user_pedro_santos');
      expect(list.isNotEmpty, isTrue);
      expect(list.first.recipientId, equals('user_pedro_santos'));
    });

    test('sends new invite', () async {
      final invite = ContractInviteEntity(
        id: 'new_inv_test',
        senderId: 'sender_1',
        senderName: 'Produtor X',
        recipientId: 'user_marcos_oliveira',
        recipientName: 'Marcos Batera',
        eventName: 'Festival de Verão',
        eventDate: DateTime(2026, 12, 10),
        eventTime: '20:00',
        eventLocation: 'Praia Clube',
        city: 'Santos',
        state: 'SP',
        cacheAmount: 900.0,
        createdAt: DateTime.now(),
      );

      final sent = await repository.sendInvite(invite);
      expect(sent.id, equals('new_inv_test'));

      final received = await repository.getInvitesForUser('user_marcos_oliveira');
      expect(received.any((i) => i.id == 'new_inv_test'), isTrue);
    });

    test('responds to invite with acceptance and negotiation', () async {
      final invite = ContractInviteEntity(
        id: 'inv_to_respond',
        senderId: 's1',
        senderName: 'Sender',
        recipientId: 'r1',
        recipientName: 'Recipient',
        eventName: 'Show',
        eventDate: DateTime(2026, 10, 30),
        eventTime: '22:00',
        eventLocation: 'Teatro',
        city: 'São Paulo',
        state: 'SP',
        cacheAmount: 500.0,
        createdAt: DateTime.now(),
      );

      await repository.sendInvite(invite);

      // Negociando contraproposta
      final negotiated = await repository.respondToInvite(
        inviteId: 'inv_to_respond',
        status: ContractStatus.emNegociacao,
        counterOfferAmount: 700.0,
      );
      expect(negotiated.status, equals(ContractStatus.emNegociacao));
      expect(negotiated.counterOfferAmount, equals(700.0));

      // Aceitando
      final accepted = await repository.respondToInvite(
        inviteId: 'inv_to_respond',
        status: ContractStatus.aceito,
      );
      expect(accepted.status, equals(ContractStatus.aceito));
    });
  });
}
