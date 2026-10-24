import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/features/videos/domain/models/musician_video_entity.dart';
import 'package:playauge/shared/widgets/app_button.dart';

/// Modal / Player Interativo de Vídeo para Solos e Ensaios dos Músicos
class MusicianVideoPlayerModal extends StatefulWidget {
  final MusicianVideoEntity video;
  final VoidCallback? onInviteMusician;

  const MusicianVideoPlayerModal({
    super.key,
    required this.video,
    this.onInviteMusician,
  });

  static void show(BuildContext context, MusicianVideoEntity video, {VoidCallback? onInviteMusician}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => MusicianVideoPlayerModal(
        video: video,
        onInviteMusician: onInviteMusician,
      ),
    );
  }

  @override
  State<MusicianVideoPlayerModal> createState() => _MusicianVideoPlayerModalState();
}

class _MusicianVideoPlayerModalState extends State<MusicianVideoPlayerModal> {
  bool _isPlaying = true;
  bool _isMuted = false;
  double _playbackPosition = 0.35; // Simulação da barra de progresso do vídeo

  @override
  Widget build(BuildContext context) {
    final v = widget.video;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header com botão fechar e instrumento
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.music_note, color: AppColors.primary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            v.instrument,
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(v.durationFormatted, style: AppTextStyles.bodySmall),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Área Principal do Vídeo (Player com Overlay de Controles)
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Thumbnail / Quadro do vídeo
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: Image.network(
                    v.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceElevated,
                      child: const Center(
                        child: Icon(Icons.videocam_rounded, size: 64, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),

                // Gradiente escuro para legibilidade dos controles
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Botão Central de Play / Pause
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ),

                // Controles Laterais (Curtir, Mute, Volume)
                Positioned(
                  right: 16,
                  bottom: 50,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => _isMuted = !_isMuted),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          const Icon(Icons.favorite, color: Colors.redAccent, size: 28),
                          const SizedBox(height: 4),
                          Text('${v.likesCount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          const Icon(Icons.remove_red_eye_rounded, color: Colors.white70, size: 24),
                          const SizedBox(height: 4),
                          Text('${v.viewsCount}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Barra de Progresso do Vídeo
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: AppColors.primary,
                        ),
                        child: Slider(
                          value: _playbackPosition,
                          onChanged: (val) => setState(() => _playbackPosition = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Rodapé com Descrição e Botão "Contratar Músico"
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  v.description,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Contratar ou Convidar Músico',
                        icon: Icons.handshake_rounded,
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.onInviteMusician != null) {
                            widget.onInviteMusician!();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
