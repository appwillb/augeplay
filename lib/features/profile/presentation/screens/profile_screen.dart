import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';
import 'package:playauge/features/videos/presentation/state/video_provider.dart';
import 'package:playauge/features/videos/presentation/widgets/musician_videos_grid.dart';
import 'package:playauge/features/videos/presentation/screens/video_call_screen.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/user_avatar.dart';
import 'package:playauge/shared/widgets/availability_badge.dart';
import 'package:playauge/shared/widgets/star_rating.dart';
import 'package:playauge/shared/widgets/custom_card.dart';
import 'edit_availability_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileEntity profile;
  final ProfileProvider profileProvider;
  final VideoProvider videoProvider;
  final UserEntity currentUser;
  final bool isMyProfile;
  final VoidCallback onInviteForGig;
  final VoidCallback onChat;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.profileProvider,
    required this.videoProvider,
    required this.currentUser,
    this.isMyProfile = false,
    required this.onInviteForGig,
    required this.onChat,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    widget.videoProvider.loadVideosForMusician(widget.profile.user.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startVideoCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          callerUser: widget.currentUser,
          targetProfile: widget.profile,
          proposedCache: widget.profile.availability.baseRate,
          onContractAgreed: widget.onInviteForGig,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.profile.user;
    final profile = widget.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(u.displayName),
        actions: [
          if (widget.isMyProfile)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAvailabilityScreen(
                      profile: profile,
                      profileProvider: widget.profileProvider,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Foto + Informações Básicas
            Row(
              children: [
                UserAvatar(
                  name: u.displayName,
                  radius: 40,
                  isVerified: u.isVerified,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.displayName, style: AppTextStyles.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        profile.instrumentsFormatted.isNotEmpty
                            ? profile.instrumentsFormatted
                            : u.roles.map((r) => r.shortLabel).join(', '),
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(u.locationFormatted, style: AppTextStyles.bodySmall),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          AvailabilityBadge(isAvailable: profile.availability.isAvailable),
                          const SizedBox(width: 10),
                          StarRating(rating: u.rating, reviewsCount: u.ratingsCount),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Métricas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric('${u.followersCount}', 'Seguidores'),
                _buildMetric('${u.followingCount}', 'Seguindo'),
                _buildMetric('${profile.yearsOfExperience} anos', 'Experiência'),
                _buildMetric('${u.rating.toStringAsFixed(1)} ★', 'Avaliação'),
              ],
            ),

            const SizedBox(height: 24),

            // Botões de Ação com CHAMADA DE VÍDEO
            if (!widget.isMyProfile) ...[
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppButton(
                      label: 'Convidar p/ Show',
                      icon: Icons.calendar_today_rounded,
                      onPressed: widget.onInviteForGig,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão de Vídeo Chamada / Audição Online
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.videocam_rounded, size: 20),
                      label: const Text(
                        'Audição Vídeo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onPressed: _startVideoCall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      side: const BorderSide(color: AppColors.surfaceBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                    onPressed: widget.onChat,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ] else ...[
              AppButton(
                label: 'Gerenciar Disponibilidade e Cachê',
                icon: Icons.edit_calendar_rounded,
                type: AppButtonType.outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditAvailabilityScreen(
                        profile: profile,
                        profileProvider: widget.profileProvider,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

            // Seletor de Abas (Vídeos Tocando vs Informações Profissionais)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.play_circle_fill_rounded),
                    text: 'Vídeos Tocando',
                  ),
                  Tab(
                    icon: Icon(Icons.badge_rounded),
                    text: 'Perfil & Cachê',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Conteúdo dinâmico das abas
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                if (_tabController.index == 0) {
                  // ABA 1: Grade de Vídeos Tocando
                  return AnimatedBuilder(
                    animation: widget.videoProvider,
                    builder: (context, _) {
                      if (widget.videoProvider.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Solos, Ensaios & Gigs', style: AppTextStyles.titleSmall),
                              Text(
                                '${widget.videoProvider.videos.length} vídeos',
                                style: const TextStyle(fontSize: 12, color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          MusicianVideosGrid(
                            videos: widget.videoProvider.videos,
                            isMyProfile: widget.isMyProfile,
                            onInviteMusician: widget.onInviteForGig,
                          ),
                        ],
                      );
                    },
                  );
                }

                // ABA 2: Dados Profissionais e Cachê
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card de Disponibilidade e Condições Profissionais
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Disponibilidade Profissional', style: AppTextStyles.titleSmall),
                              AvailabilityBadge(isAvailable: profile.availability.isAvailable),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (profile.availability.baseRate != null)
                            Text(
                              'Cachê base sugerido: ${CurrencyFormatter.formatBRL(profile.availability.baseRate!)}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(height: 6),
                          Text('Raio de atendimento: ${profile.availability.serviceRadiusKm} km', style: AppTextStyles.bodySmall),
                          if (profile.availability.statesServed.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text('Estados atendidos: ${profile.availability.statesServed.join(', ')}', style: AppTextStyles.bodySmall),
                          ],
                          if (profile.availability.notes != null) ...[
                            const SizedBox(height: 8),
                            Text('Observações: ${profile.availability.notes}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Biografia
                    const Text('Sobre o Profissional', style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    Text(u.bio, style: AppTextStyles.bodyMedium),

                    const SizedBox(height: 20),

                    // Gêneros Musicais
                    if (profile.genres.isNotEmpty) ...[
                      const Text('Gêneros Musicais', style: AppTextStyles.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.genres.map((g) {
                          return Chip(
                            label: Text(g, style: const TextStyle(fontSize: 12)),
                            backgroundColor: AppColors.surfaceElevated,
                            side: const BorderSide(color: AppColors.surfaceBorder),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Integrantes da banda se houver
                    if (profile.bandMemberNames.isNotEmpty) ...[
                      const Text('Integrantes da Banda', style: AppTextStyles.titleSmall),
                      const SizedBox(height: 8),
                      ...profile.bandMemberNames.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.music_note, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(m, style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleMedium),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
