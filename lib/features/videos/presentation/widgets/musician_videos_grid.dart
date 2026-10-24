import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/features/videos/domain/models/musician_video_entity.dart';
import 'package:playauge/features/videos/presentation/widgets/musician_video_player_modal.dart';

/// Grade de Vídeos de Solos e Ensaios do Músico (Exibida no Perfil)
class MusicianVideosGrid extends StatelessWidget {
  final List<MusicianVideoEntity> videos;
  final VoidCallback? onInviteMusician;
  final VoidCallback? onUploadNewVideo;
  final bool isMyProfile;

  const MusicianVideosGrid({
    super.key,
    required this.videos,
    this.onInviteMusician,
    this.onUploadNewVideo,
    this.isMyProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          children: [
            const Icon(Icons.video_library_outlined, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text(
              'Nenhum vídeo publicado ainda',
              style: AppTextStyles.titleSmall,
            ),
            const SizedBox(height: 6),
            const Text(
              'Grave trechos de solos, afinação e apresentações para contratantes ouvirem sua pegada.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (isMyProfile && onUploadNewVideo != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onUploadNewVideo,
                icon: const Icon(Icons.videocam_rounded),
                label: const Text('Enviar Primeiro Vídeo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textInverse,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final video = videos[index];

        return GestureDetector(
          onTap: () {
            MusicianVideoPlayerModal.show(
              context,
              video,
              onInviteMusician: onInviteMusician,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Capa do Vídeo
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(Icons.movie_creation_outlined, color: AppColors.primary, size: 36),
                      ),
                    ),
                  ),

                  // Gradiente escuro para contraste
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Ícone de Play central
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.8), width: 1.5),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                  ),

                  // Tag de Duração no topo direito
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.durationFormatted,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),

                  // Tag do Instrumento no topo esquerdo
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.instrument,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),

                  // Detalhes no Rodapé (Título e Métricas)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                            const SizedBox(width: 4),
                            Text(
                              '${video.likesCount}',
                              style: const TextStyle(fontSize: 10, color: Colors.white70),
                            ),
                            const Spacer(),
                            const Icon(Icons.remove_red_eye, size: 12, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              '${video.viewsCount}',
                              style: const TextStyle(fontSize: 10, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
