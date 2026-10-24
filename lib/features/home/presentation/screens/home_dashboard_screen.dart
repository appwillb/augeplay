import 'package:flutter/material.dart';
import 'package:playauge/core/audio/audio_player_service.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/features/discovery/presentation/state/discovery_provider.dart';
import 'package:playauge/features/opportunities/presentation/state/opportunity_provider.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/shared/widgets/custom_card.dart';
import 'package:playauge/shared/widgets/user_avatar.dart';
import 'package:playauge/shared/widgets/availability_badge.dart';
import 'package:playauge/shared/widgets/star_rating.dart';

class HomeDashboardScreen extends StatelessWidget {
  final AuthProvider authProvider;
  final DiscoveryProvider discoveryProvider;
  final OpportunityProvider opportunityProvider;
  final MusicProvider musicProvider;
  final AudioPlayerService audioService;
  final void Function(int tabIndex) onNavigateTab;
  final void Function(String profileId) onOpenProfile;

  const HomeDashboardScreen({
    super.key,
    required this.authProvider,
    required this.discoveryProvider,
    required this.opportunityProvider,
    required this.musicProvider,
    required this.audioService,
    required this.onNavigateTab,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final user = authProvider.currentUser;
    final userName = user != null ? user.displayName : 'Visitante';
    final userCity = user != null ? '${user.city} - ${user.state}' : 'São Paulo - SP';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 30,
              height: 30,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.textInverse, size: 18),
              ),
            ),
            const SizedBox(width: 10),
            const Text('GPSMusic', style: AppTextStyles.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Central de Notificações')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => onNavigateTab(1), // Aba Descobrir
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, color: AppColors.primary),
            tooltip: 'Meu Perfil',
            onPressed: () => onNavigateTab(4), // Aba Perfil
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de Boas-vindas com botão direto de Perfil
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olá, $userName 👋', style: AppTextStyles.displayMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Encontre músicos e faça sua música acontecer em qualquer lugar.',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.person_rounded, size: 18),
                    label: const Text('Meu Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () => onNavigateTab(4),
                  ),
                ],
              ),
            ),

            // Card Rápido de Ação: "Precisa de músicos para um show?"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(userCity, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Vai tocar em outra cidade?', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 4),
                          Text('Encontre bateristas, guitarristas e técnicos disponíveis na região.', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => onNavigateTab(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textInverse,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Buscar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Seção: 🎸 Músicos Próximos
            _buildSectionHeader(
              title: '🎸 Músicos Disponíveis',
              onSeeAll: () => onNavigateTab(1),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: discoveryProvider,
                builder: (context, _) {
                  final profiles = discoveryProvider.profiles;
                  if (profiles.isEmpty) {
                    return const Center(child: Text('Nenhum profissional encontrado'));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final p = profiles[index];
                      return Container(
                        width: 170,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: CustomCard(
                          padding: const EdgeInsets.all(12),
                          onTap: () => onOpenProfile(p.user.id),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              UserAvatar(name: p.user.displayName, radius: 26, isVerified: p.user.isVerified),
                              const SizedBox(height: 8),
                              Text(
                                p.user.displayName,
                                style: AppTextStyles.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                p.instruments.isNotEmpty ? p.instruments.first : p.user.roles.first.shortLabel,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p.user.city} - ${p.user.state}',
                                style: AppTextStyles.bodySmall,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AvailabilityBadge(isAvailable: p.availability.isAvailable, compact: true),
                                  StarRating(rating: p.user.rating),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Seção: 🎯 Oportunidades em Destaque
            _buildSectionHeader(
              title: '🎯 Oportunidades & Vagas',
              onSeeAll: () => onNavigateTab(1),
            ),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: opportunityProvider,
              builder: (context, _) {
                final opps = opportunityProvider.opportunities;
                if (opps.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Nenhuma oportunidade no momento'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: opps.take(3).length,
                  itemBuilder: (context, index) {
                    final op = opps[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CustomCard(
                        onTap: () => onNavigateTab(1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    op.type.label,
                                    style: AppTextStyles.badgeText.copyWith(color: AppColors.secondaryLight),
                                  ),
                                ),
                                if (op.cacheAmount != null)
                                  Text(
                                    CurrencyFormatter.formatBRL(op.cacheAmount!),
                                    style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(op.title, style: AppTextStyles.titleSmall),
                            const SizedBox(height: 4),
                            Text(
                              '${op.locationFormatted} • Instrumento: ${op.instrumentNeeded} • ${op.genre}',
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Publicado por ${op.creatorName}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                ),
                                const Text(
                                  'Ver Detalhes →',
                                  style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            // Seção: 🎵 Novas Músicas & Demos
            _buildSectionHeader(
              title: '🎵 Novas Músicas & Demos',
              onSeeAll: () => onNavigateTab(1),
            ),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: musicProvider,
              builder: (context, _) {
                final songs = musicProvider.songs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: songs.take(2).length,
                  itemBuilder: (context, index) {
                    final s = songs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CustomCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.music_note, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.title, style: AppTextStyles.titleSmall),
                                  Text('${s.artistName} • ${s.genre}', style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 36),
                              onPressed: () {
                                audioService.playSong(s, queue: songs);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'Ver todos',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
