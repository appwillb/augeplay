import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';

class EditAvailabilityScreen extends StatefulWidget {
  final ProfileEntity profile;
  final ProfileProvider profileProvider;

  const EditAvailabilityScreen({
    super.key,
    required this.profile,
    required this.profileProvider,
  });

  @override
  State<EditAvailabilityScreen> createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  late bool _isAvailable;
  late TextEditingController _baseRateController;
  late TextEditingController _radiusController;
  late TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.profile.availability;
    _isAvailable = a.isAvailable;
    _baseRateController = TextEditingController(
      text: a.baseRate != null ? a.baseRate!.toStringAsFixed(0) : '650',
    );
    _radiusController = TextEditingController(text: a.serviceRadiusKm.toString());
    _notesController = TextEditingController(text: a.notes ?? '');
  }

  @override
  void dispose() {
    _baseRateController.dispose();
    _radiusController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final rawRateText = _baseRateController.text.trim().replaceAll(',', '.');
    final parsedRate = double.tryParse(rawRateText);

    final newAvailability = widget.profile.availability.copyWith(
      isAvailable: _isAvailable,
      baseRate: parsedRate,
      serviceRadiusKm: int.tryParse(_radiusController.text.trim()) ?? 100,
      notes: _notesController.text.trim(),
    );

    try {
      await widget.profileProvider.updateAvailability(
        newAvailability,
        userId: widget.profile.user.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Disponibilidade e Cachê atualizados com sucesso!'),
          ),
        );
        Navigator.pop(context, newAvailability);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Erro ao salvar: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Disponibilidade & Cachê'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Switch 🟢 vs ⚪
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isAvailable
                    ? AppColors.availableGreen.withOpacity(0.12)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isAvailable
                      ? AppColors.availableGreen.withOpacity(0.5)
                      : AppColors.surfaceBorder,
                ),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _isAvailable ? '🟢 Disponível para Trabalho' : '⚪ Indisponível no Momento',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: _isAvailable ? AppColors.availableGreen : AppColors.textSecondary,
                  ),
                ),
                subtitle: Text(
                  _isAvailable
                      ? 'Seu perfil aparecerá nas buscas para novos shows e gravações.'
                      : 'Você não receberá novos convites de trabalho temporariamente.',
                  style: AppTextStyles.bodySmall,
                ),
                value: _isAvailable,
                activeColor: AppColors.availableGreen,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
            ),

            const SizedBox(height: 24),

            // Cachê Base
            AppTextField(
              label: 'Cachê Base / Diária Sugerida (R\$)',
              hint: 'Ex: 650',
              controller: _baseRateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.attach_money_rounded,
            ),
            const SizedBox(height: 16),

            // Raio de Atendimento
            AppTextField(
              label: 'Raio de Atendimento (km)',
              hint: 'Ex: 200',
              controller: _radiusController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.route_rounded,
            ),
            const SizedBox(height: 16),

            // Observações
            AppTextField(
              label: 'Condições e Requisitos Técnicos',
              hint: 'Ex: Possuo transporte próprio, equipamento valvulado e sistema in-ear.',
              controller: _notesController,
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            AppButton(
              label: 'Salvar Configurações',
              icon: Icons.check_circle_rounded,
              isLoading: _isSaving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
