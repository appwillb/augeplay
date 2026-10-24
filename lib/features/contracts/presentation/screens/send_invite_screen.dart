import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/validators.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';
import 'package:playauge/features/contracts/presentation/state/contract_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';

class SendInviteScreen extends StatefulWidget {
  final UserEntity currentUser;
  final UserEntity recipientUser;
  final ContractProvider contractProvider;

  const SendInviteScreen({
    super.key,
    required this.currentUser,
    required this.recipientUser,
    required this.contractProvider,
  });

  @override
  State<SendInviteScreen> createState() => _SendInviteScreenState();
}

class _SendInviteScreenState extends State<SendInviteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _cityController = TextEditingController(text: 'São Paulo');
  final _cacheController = TextEditingController(text: '650');
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventLocationController.dispose();
    _cityController.dispose();
    _cacheController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final invite = ContractInviteEntity(
      id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
      senderId: widget.currentUser.id,
      senderName: widget.currentUser.displayName,
      senderAvatarUrl: widget.currentUser.avatarUrl,
      recipientId: widget.recipientUser.id,
      recipientName: widget.recipientUser.displayName,
      recipientAvatarUrl: widget.recipientUser.avatarUrl,
      eventName: _eventNameController.text.trim(),
      eventDate: _selectedDate,
      eventTime: '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      eventLocation: _eventLocationController.text.trim(),
      city: _cityController.text.trim(),
      state: 'SP',
      cacheAmount: double.parse(_cacheController.text.replaceAll(',', '.')),
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    await widget.contractProvider.sendInvite(invite);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Convite enviado com sucesso para ${widget.recipientUser.displayName}!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Convidar ${widget.recipientUser.displayName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Detalhes da Apresentação / Trabalho',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Nome do Evento / Show',
                hint: 'Ex: Show Villa Country',
                controller: _eventNameController,
                validator: (v) => Validators.validateRequired(v, 'Nome do evento'),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data do Show', style: AppTextStyles.labelMedium),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Horário', style: AppTextStyles.labelMedium),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.access_time, size: 16),
                          label: Text('${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) setState(() => _selectedTime = picked);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Local / Estúdio / Casa de Show',
                hint: 'Ex: Espaço Unimed, Barra Funda',
                controller: _eventLocationController,
                validator: (v) => Validators.validateRequired(v, 'Local'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Cidade do Evento',
                hint: 'Ex: São Paulo',
                controller: _cityController,
                validator: (v) => Validators.validateRequired(v, 'Cidade'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Valor Proposto do Cachê (R\$)',
                hint: 'Ex: 650.00',
                controller: _cacheController,
                keyboardType: TextInputType.number,
                validator: (v) => Validators.validatePositiveNumber(v, 'Cachê'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Observações e Instruções (Passagem de som, repertório, alimentação)',
                hint: 'Ex: Passagem de som às 17h. Repertório já disponível na aba de ensaios.',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 28),

              AppButton(
                label: 'Enviar Convite Profissional',
                icon: Icons.send_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
