import 'package:flutter/material.dart';
import 'package:playauge/core/constants/app_constants.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/audio/audio_player_service.dart';
import 'package:playauge/core/utils/validators.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';

enum AudioFileType {
  mp3,
  wav,
  aac,
  m4a,
}

/// Tela de Upload e Envio de Músicas e Composições com Pré-escuta Imediata no Player Global
class UploadSongScreen extends StatefulWidget {
  final UserEntity currentUser;
  final MusicProvider musicProvider;
  final AudioPlayerService audioService;

  const UploadSongScreen({
    super.key,
    required this.currentUser,
    required this.musicProvider,
    required this.audioService,
  });

  @override
  State<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends State<UploadSongScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _composerController = TextEditingController();
  final _keyController = TextEditingController(text: 'E Maior');
  final _bpmController = TextEditingController(text: '128');
  final _lyricsController = TextEditingController();

  String _selectedGenre = AppConstants.musicGenres.first;
  bool _isCompositionForSale = false;
  bool _isUploading = false;
  String? _selectedAudioFileName = 'audio_ensaio_master_v1.mp3';
  Duration _selectedAudioDuration = const Duration(minutes: 3, seconds: 20);

  @override
  void dispose() {
    _titleController.dispose();
    _composerController.dispose();
    _keyController.dispose();
    _bpmController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  void _simulatePickAudioFile() {
    setState(() {
      _selectedAudioFileName = 'take_estudio_${DateTime.now().millisecondsSinceEpoch % 1000}.mp3';
      _selectedAudioDuration = const Duration(minutes: 3, seconds: 45);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text('Arquivo selecionado: $_selectedAudioFileName (3:45)'),
      ),
    );
  }

  void _handleUploadAndPlay() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    final songId = 'song_${DateTime.now().millisecondsSinceEpoch}';
    final song = SongEntity(
      id: songId,
      title: _titleController.text.trim(),
      artistId: widget.currentUser.id,
      artistName: widget.currentUser.displayName,
      composerName: _composerController.text.trim().isNotEmpty ? _composerController.text.trim() : null,
      genre: _selectedGenre,
      audioUrl: 'https://cdn.gpsmusic.com/audio/$songId.mp3',
      musicalKey: _keyController.text.trim(),
      bpm: int.tryParse(_bpmController.text.trim()),
      lyrics: _lyricsController.text.trim(),
      releaseDate: DateTime.now(),
    );

    await widget.musicProvider.publishSong(song);

    if (_isCompositionForSale) {
      final comp = CompositionEntity(
        id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        composerId: widget.currentUser.id,
        composerName: widget.currentUser.displayName,
        genre: _selectedGenre,
        demoAudioUrl: song.audioUrl,
        lyrics: _lyricsController.text.trim(),
        lookingForArtist: true,
        createdAt: DateTime.now(),
      );
      await widget.musicProvider.publishComposition(comp);
    }

    if (mounted) {
      setState(() => _isUploading = false);

      // Inicia reprodução imediata no Player Global Persistente
      widget.audioService.playSong(song);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Música "${song.title}" publicada com sucesso! Tocando no Player Global.'),
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
        title: const Text('Upload & Envio de Músicas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Área de Upload de Arquivo de Áudio
              GestureDetector(
                onTap: _simulatePickAudioFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.6), style: BorderStyle.solid, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 40),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Selecione o arquivo de áudio (MP3, WAV, AAC)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedAudioFileName != null
                            ? 'Arquivo: $_selectedAudioFileName'
                            : 'Toque para buscar da memória do celular ou gravar',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedAudioFileName != null ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Título da Música
              AppTextField(
                label: 'Título da Música / Gravação *',
                hint: 'Ex: Deixa o Som Rolar (Ao Vivo)',
                controller: _titleController,
                validator: (val) => Validators.validateRequired(val, 'Título'),
              ),

              const SizedBox(height: 16),

              // Compositor Original
              AppTextField(
                label: 'Compositor(es)',
                hint: 'Ex: Seu nome ou parceiro de composição',
                controller: _composerController,
              ),

              const SizedBox(height: 16),

              // Gênero Musical
              const Text('Gênero Musical *', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGenre,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceElevated,
                    items: AppConstants.musicGenres.map((g) {
                      return DropdownMenuItem(value: g, child: Text(g));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGenre = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Linha Técnica: Tom e BPM
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Tom Musical',
                      hint: 'Ex: Sol Maior (G)',
                      controller: _keyController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'BPM (Andamento)',
                      hint: 'Ex: 120',
                      keyboardType: TextInputType.number,
                      controller: _bpmController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Letra / Cifra da Música
              AppTextField(
                label: 'Letra da Música & Cifras',
                hint: 'Cole aqui a letra completa ou observações para a banda...',
                controller: _lyricsController,
                maxLines: 4,
              ),

              const SizedBox(height: 16),

              // Switch para disponibilizar como composição autoral
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: const Text('Disponibilizar no Mural de Compositores'),
                subtitle: const Text('Artistas e cantores poderão demonstrar interesse em gravar esta faixa.'),
                value: _isCompositionForSale,
                onChanged: (val) => setState(() => _isCompositionForSale = val),
              ),

              const SizedBox(height: 24),

              // Botão Enviar & Ouvir
              AppButton(
                label: _isUploading ? 'Enviando faixa...' : 'Enviar Música e Tocar no Player',
                icon: Icons.play_circle_fill_rounded,
                isLoading: _isUploading,
                onPressed: _isUploading ? null : _handleUploadAndPlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
