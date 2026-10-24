import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/features/videos/domain/models/musician_video_entity.dart';
import 'package:playauge/features/videos/presentation/widgets/web_media_view.dart';
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

          // Área Principal do Vídeo (Player HTML5 Real)
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: createVideoPlayerView(
                    viewId: 'modal_${v.id}',
                    videoUrl: v.videoUrl,
                    isPlaying: _isPlaying,
                    isMuted: _isMuted,
                  ),
                ),

                // Controles Rápidos flutuantes
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Row(
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.black54),
                        icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 20),
                        onPressed: () => setState(() => _isMuted = !_isMuted),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.black54),
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 20),
                        onPressed: () => setState(() => _isPlaying = !_isPlaying),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Informações do Músico e Botão de Contratação
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surfaceElevated,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  v.description,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 4),
                        Text('${v.likesCount}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.visibility_rounded, color: AppColors.textSecondary, size: 18),
                        const SizedBox(width: 4),
                        Text('${v.viewsCount} visualizações', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    if (widget.onInviteMusician != null)
                      AppButton(
                        label: 'Convidar para Show',
                        icon: Icons.calendar_today_rounded,
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onInviteMusician!();
                        },
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
