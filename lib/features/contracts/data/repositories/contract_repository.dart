import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';

abstract class ContractRepository {
  Future<List<ContractInviteEntity>> getInvitesForUser(String userId);
  Future<ContractInviteEntity> sendInvite(ContractInviteEntity invite);
  Future<ContractInviteEntity> respondToInvite({
    required String inviteId,
    required ContractStatus status,
    double? counterOfferAmount,
  });
}

class ContractRepositoryImpl implements ContractRepository {
  final List<ContractInviteEntity> _invites = List.from(MockData.invites);

  @override
  Future<List<ContractInviteEntity>> getInvitesForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _invites
        .where((i) => i.senderId == userId || i.recipientId == userId)
        .toList();
  }

  @override
  Future<ContractInviteEntity> sendInvite(ContractInviteEntity invite) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _invites.insert(0, invite);
    return invite;
  }

  @override
  Future<ContractInviteEntity> respondToInvite({
    required String inviteId,
    required ContractStatus status,
    double? counterOfferAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _invites.indexWhere((i) => i.id == inviteId);
    if (index != -1) {
      final updated = _invites[index].copyWith(
        status: status,
        counterOfferAmount: counterOfferAmount,
      );
      _invites[index] = updated;
      return updated;
    }
    throw Exception('Convite não encontrado');
  }
}
