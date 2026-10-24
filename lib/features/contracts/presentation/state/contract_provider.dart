import 'package:flutter/foundation.dart';
import 'package:playauge/features/contracts/data/repositories/contract_repository.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';

class ContractProvider extends ChangeNotifier {
  final ContractRepository _repository;

  List<ContractInviteEntity> _invites = [];
  bool _isLoading = false;

  ContractProvider(this._repository);

  List<ContractInviteEntity> get invites => List.unmodifiable(_invites);
  bool get isLoading => _isLoading;

  Future<void> loadInvites(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _invites = await _repository.getInvitesForUser(userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendInvite(ContractInviteEntity invite) async {
    await _repository.sendInvite(invite);
    _invites.insert(0, invite);
    notifyListeners();
  }

  Future<void> respondToInvite({
    required String inviteId,
    required ContractStatus status,
    double? counterOfferAmount,
  }) async {
    final updated = await _repository.respondToInvite(
      inviteId: inviteId,
      status: status,
      counterOfferAmount: counterOfferAmount,
    );

    final index = _invites.indexWhere((i) => i.id == inviteId);
    if (index != -1) {
      _invites[index] = updated;
      notifyListeners();
    }
  }
}
