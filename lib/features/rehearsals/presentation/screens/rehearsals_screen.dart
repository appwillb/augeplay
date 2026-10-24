import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/date_formatter.dart';
import 'package:playauge/features/rehearsals/data/repositories/rehearsal_repository.dart';
import 'package:playauge/features/rehearsals/domain/models/rehearsal_entity.dart';
import 'package:playauge/shared/widgets/custom_card.dart';
import 'package:playauge/shared/widgets/state_views.dart';

class RehearsalsScreen extends StatefulWidget {
  final RehearsalRepository rehearsalRepository;
  final String currentUserName;

  const RehearsalsScreen({
    super.key,
    required this.rehearsalRepository,
    required this.currentUserName,
  });

  @override
  State<RehearsalsScreen> createState() => _RehearsalsScreenState();
}

class _RehearsalsScreenState extends State<RehearsalsScreen> {
  List<RehearsalEntity> _rehearsals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRehearsals();
  }

  Future<void> _loadRehearsals() async {
    setState(() => _isLoading = true);
    final list = await widget.rehearsalRepository.getRehearsals();
    setState(() {
      _rehearsals = list;
      _isLoading = false;
    });
  }

  void _showAddRepertoireDialog(String rehearsalId) {
    final titleController = TextEditingController();
    final keyController = TextEditingController(text: 'G Maior');
    final bpmController = TextEditingController(text: '120');
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Adicionar Música ao Repertório', style: AppTextStyles.titleMedium),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título da Música'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: keyController,
                      decoration: const InputDecoration(labelText: 'Tom (Key)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: bpmController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'BPM'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Observação / Arranjo'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                final item = RepertoireItem(
                  id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
                  songTitle: titleController.text.trim(),
                  musicalKey: keyController.text.trim(),
                  bpm: int.tryParse(bpmController.text.trim()),
                  notes: notesController.text.trim(),
                );
                await widget.rehearsalRepository.addRepertoireItem(rehearsalId, item);
                Navigator.pop(context);
                _loadRehearsals();
              }
            },
            child: const Text('Adicionar'),
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
        title: const Text('Meus Ensaios & Repertório'),
      ),
      body: _isLoading
          ? const LoadingStateView(message: 'Carregando ensaios...')
          : _rehearsals.isEmpty
              ? const EmptyStateView(
                  icon: Icons.event_available_rounded,
                  title: 'Nenhum ensaio agendado',
                  subtitle: 'Agende ensaios com sua banda e adicione o repertório para a equipe.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rehearsals.length,
                  itemBuilder: (context, index) {
                    final r = _rehearsals[index];
                    final isConfirmed = r.confirmedParticipantNames.contains(widget.currentUserName);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(r.bandOrArtistName, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                                Text('${DateFormatter.formatDate(r.date)} às ${r.time}', style: AppTextStyles.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(r.title, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 4),
                            Text('${r.studioName} • ${r.locationAddress}', style: AppTextStyles.bodySmall),
                            const SizedBox(height: 12),

                            // Lista de Participantes
                            Text('Músicos Convocados:', style: AppTextStyles.labelMedium),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: r.participantNames.map((name) {
                                final confirmed = r.confirmedParticipantNames.contains(name);
                                return Chip(
                                  avatar: Icon(
                                    confirmed ? Icons.check_circle : Icons.schedule,
                                    size: 16,
                                    color: confirmed ? AppColors.availableGreen : AppColors.pendingYellow,
                                  ),
                                  label: Text(name, style: const TextStyle(fontSize: 12)),
                                  backgroundColor: AppColors.surfaceElevated,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 14),

                            // Seção de Repertório
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Repertório (${r.repertoire.length} músicas)', style: AppTextStyles.titleSmall),
                                TextButton.icon(
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Adicionar Música', style: TextStyle(fontSize: 12)),
                                  onPressed: () => _showAddRepertoireDialog(r.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            ...r.repertoire.asMap().entries.map((entry) {
                              final idx = entry.key + 1;
                              final item = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text('$idx.', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.songTitle, style: AppTextStyles.titleSmall),
                                          if (item.notes != null && item.notes!.isNotEmpty)
                                            Text(item.notes!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ),
                                    if (item.musicalKey != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(item.musicalKey!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    if (item.bpm != null) ...[
                                      const SizedBox(width: 6),
                                      Text('${item.bpm} BPM', style: AppTextStyles.bodySmall),
                                    ],
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 12),

                            // Botão Confirmar Presença
                            if (!isConfirmed)
                              ElevatedButton(
                                onPressed: () async {
                                  await widget.rehearsalRepository.confirmPresence(r.id, widget.currentUserName);
                                  _loadRehearsals();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Presença confirmada no ensaio!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.availableGreen,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('CONFIRMAR MINHA PRESENÇA NO ENSAIO'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
