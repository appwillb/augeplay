import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/core/utils/date_formatter.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';
import 'package:playauge/features/contracts/presentation/state/contract_provider.dart';
import 'package:playauge/shared/widgets/custom_card.dart';
import 'package:playauge/shared/widgets/state_views.dart';

class InvitationsScreen extends StatelessWidget {
  final ContractProvider contractProvider;
  final String currentUserId;

  const InvitationsScreen({
    super.key,
    required this.contractProvider,
    required this.currentUserId,
  });

  void _showNegotiateDialog(BuildContext context, ContractInviteEntity invite) {
    final counterController = TextEditingController(
      text: (invite.cacheAmount + 150).toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Propor Novo Cachê', style: AppTextStyles.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cachê ofertado originalmente: ${CurrencyFormatter.formatBRL(invite.cacheAmount)}',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: counterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sua Contraproposta (R\$)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(counterController.text.trim());
              if (val != null) {
                contractProvider.respondToInvite(
                  inviteId: invite.id,
                  status: ContractStatus.emNegociacao,
                  counterOfferAmount: val,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contraproposta enviada para o contratante!')),
                );
              }
            },
            child: const Text('Enviar Proposta'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Convites de Trabalho & Cachês'),
      ),
      body: AnimatedBuilder(
        animation: contractProvider,
        builder: (context, _) {
          final invites = contractProvider.invites;
          if (invites.isEmpty) {
            return const EmptyStateView(
              icon: Icons.assignment_outlined,
              title: 'Você ainda não possui convites',
              subtitle: 'Quando artistas e bandas convidarem você para shows ou gravações, eles aparecerão aqui.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invites.length,
            itemBuilder: (context, index) {
              final inv = invites[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(inv.status).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              inv.status.label,
                              style: AppTextStyles.badgeText.copyWith(color: _getStatusColor(inv.status)),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatBRL(inv.counterOfferAmount ?? inv.cacheAmount),
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(inv.eventName, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 4),
                      Text('Contratante: ${inv.senderName}', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Data: ${DateFormatter.formatDate(inv.eventDate)} às ${inv.eventTime} • ${inv.eventLocation} (${inv.city})',
                        style: AppTextStyles.bodySmall,
                      ),
                      if (inv.notes != null) ...[
                        const SizedBox(height: 8),
                        Text('Obs: ${inv.notes}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                      if (inv.status == ContractStatus.pendente) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.availableGreen),
                                onPressed: () {
                                  contractProvider.respondToInvite(
                                    inviteId: inv.id,
                                    status: ContractStatus.aceito,
                                  );
                                },
                                child: const Text('ACEITAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showNegotiateDialog(context, inv),
                                child: const Text('NEGOCIAR'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.error),
                              onPressed: () {
                                contractProvider.respondToInvite(
                                  inviteId: inv.id,
                                  status: ContractStatus.recusado,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(ContractStatus status) {
    switch (status) {
      case ContractStatus.pendente:
        return AppColors.pendingYellow;
      case ContractStatus.aceito:
      case ContractStatus.concluido:
        return AppColors.availableGreen;
      case ContractStatus.recusado:
      case ContractStatus.cancelado:
        return AppColors.error;
      case ContractStatus.emNegociacao:
        return AppColors.secondaryLight;
    }
  }
}
