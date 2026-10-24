import 'package:flutter/material.dart';
import 'package:playauge/core/constants/app_constants.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/validators.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';

enum PublishCategory {
  musicaLancada,
  composicaoDemo,
}

class PublishSongScreen extends StatefulWidget {
  final UserEntity currentUser;
  final MusicProvider musicProvider;

  const PublishSongScreen({
    super.key,
    required this.currentUser,
    required this.musicProvider,
  });

  @override
  State<PublishSongScreen> createState() => _PublishSongScreenState();
}

class _PublishSongScreenState extends State<PublishSongScreen> {
  final _formKey = GlobalKey<FormState>();
  PublishCategory _category = PublishCategory.musicaLancada;

  final _titleController = TextEditingController();
  final _composerController = TextEditingController();
  final _keyController = TextEditingController(text: 'G Maior');
  final _bpmController = TextEditingController(text: '120');
  final _lyricsController = TextEditingController();
  String _selectedGenre = AppConstants.musicGenres.first;

  // Flags para compositores
  bool _lookingForArtist = true;
  bool _lookingForProducer = false;
  bool _lookingForPartnership = false;

  @override
  void dispose() {
    _titleController.dispose();
    _composerController.dispose();
    _keyController.dispose();
    _bpmController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_category == PublishCategory.musicaLancada) {
      final song = SongEntity(
        id: 'song_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        artistId: widget.currentUser.id,
        artistName: widget.currentUser.displayName,
        composerName: _composerController.text.trim().isNotEmpty ? _composerController.text.trim() : null,
        genre: _selectedGenre,
        audioUrl: 'https://cdn.gpsmusic.com/demo/sample.mp3',
        musicalKey: _keyController.text.trim(),
        bpm: int.tryParse(_bpmController.text.trim()),
        lyrics: _lyricsController.text.trim(),
        releaseDate: DateTime.now(),
      );

      await widget.musicProvider.publishSong(song);
    } else {
      final comp = CompositionEntity(
        id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        composerId: widget.currentUser.id,
        composerName: widget.currentUser.displayName,
        genre: _selectedGenre,
        musicalKey: _keyController.text.trim(),
        bpm: int.tryParse(_bpmController.text.trim()),
        lyrics: _lyricsController.text.trim(),
        createdAt: DateTime.now(),
        lookingForArtist: _lookingForArtist,
        lookingForProducer: _lookingForProducer,
        lookingForPartnership: _lookingForPartnership,
      );

      await widget.musicProvider.publishComposition(comp);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_category == PublishCategory.musicaLancada
              ? 'Música publicada com sucesso no seu catálogo!'
              : 'Composição cadastrada! Artistas e produtores agora podem encontrá-la.'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Publicar Música ou Obra'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seletor de Tipo (Música Lançada vs Composição / Letra / Demo)
              SegmentedButton<PublishCategory>(
                segments: const [
                  ButtonSegment(
                    value: PublishCategory.musicaLancada,
                    label: Text('Música Lançada'),
                    icon: Icon(Icons.music_note),
                  ),
                  ButtonSegment(
                    value: PublishCategory.composicaoDemo,
                    label: Text('Composição / Letra'),
                    icon: Icon(Icons.edit_note),
                  ),
                ],
                selected: {_category},
                onSelectionChanged: (set) => setState(() => _category = set.first),
              ),

              const SizedBox(height: 20),

              AppTextField(
                label: 'Título da Obra',
                hint: 'Ex: Estrada do Destino',
                controller: _titleController,
                validator: (v) => Validators.validateRequired(v, 'Título'),
              ),
              const SizedBox(height: 16),

              if (_category == PublishCategory.musicaLancada) ...[
                AppTextField(
                  label: 'Compositor(es)',
                  hint: 'Ex: Ana Martins',
                  controller: _composerController,
                ),
                const SizedBox(height: 16),
              ],

              // Gênero Musical
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gênero Musical', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedGenre,
                    decoration: const InputDecoration(),
                    items: AppConstants.musicGenres
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGenre = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tom e BPM
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Tom Musical (Key)',
                      hint: 'Ex: G Maior / Am',
                      controller: _keyController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'BPM',
                      hint: 'Ex: 118',
                      controller: _bpmController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Upload de Áudio Simulado (MP3/WAV)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Arquivo de Áudio (MP3 / WAV)', style: AppTextStyles.titleSmall),
                          Text('demo_sample_track.mp3 (3.8 MB)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.availableGreen)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Arquivo de áudio selecionado!')),
                        );
                      },
                      child: const Text('Alterar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Letra
              AppTextField(
                label: 'Letra Completa / Cifra',
                hint: 'Insira aqui a letra da música para os músicos e artistas acompanharem...',
                controller: _lyricsController,
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Se for Composição: Marcações de busca de parceiros
              if (_category == PublishCategory.composicaoDemo) ...[
                Text('Procura parceiros para esta música?', style: AppTextStyles.titleSmall),
                const SizedBox(height: 6),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('PROCURA-SE ARTISTA (para gravar a faixa)'),
                  value: _lookingForArtist,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _lookingForArtist = v ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('PROCURA-SE PRODUTOR MUSICAL (para arranjo)'),
                  value: _lookingForProducer,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _lookingForProducer = v ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('PROCURA-SE PARCERIA / CO-WRITING'),
                  value: _lookingForPartnership,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _lookingForPartnership = v ?? false),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 24),

              AppButton(
                label: _category == PublishCategory.musicaLancada
                    ? 'Lançar Música na Plataforma'
                    : 'Cadastrar Composição',
                icon: Icons.check_circle_outline,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

