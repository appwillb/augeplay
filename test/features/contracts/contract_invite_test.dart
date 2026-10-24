import 'package:test/test.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';

void main() {
  group('ContractInviteEntity Tests', () {
    test('ContractStatus labels', () {
      expect(ContractStatus.pendente.label, equals('Pendente'));
      expect(ContractStatus.aceito.label, contains('Confirmado'));
      expect(ContractStatus.recusado.label, equals('Recusado'));
      expect(ContractStatus.emNegociacao.label, equals('Em Negociação'));
    });

    test('ContractInviteEntity serialization and copyWith', () {
      final invite = ContractInviteEntity(
        id: 'inv_1',
        senderId: 'user_1',
        senderName: 'João Silva',
        recipientId: 'user_2',
        recipientName: 'Pedro Santos',
        eventName: 'Show Arena Sertaneja',
        eventDate: DateTime(2026, 10, 25),
        eventTime: '21:00',
        eventLocation: 'Espaço Hall',
        city: 'São Paulo',
        state: 'SP',
        cacheAmount: 650.0,
        createdAt: DateTime(2026, 10, 5),
      );

      final json = invite.toJson();
      expect(json['cacheAmount'], equals(650.0));
      expect(json['status'], equals('pendente'));

      final fromJson = ContractInviteEntity.fromJson(json);
      expect(fromJson.senderName, equals('João Silva'));
      expect(fromJson.cacheAmount, equals(650.0));
      expect(fromJson.status, equals(ContractStatus.pendente));

      final updated = invite.copyWith(
        status: ContractStatus.emNegociacao,
        counterOfferAmount: 800.0,
      );
      expect(updated.status, equals(ContractStatus.emNegociacao));
      expect(updated.counterOfferAmount, equals(800.0));
    });
  });
}
