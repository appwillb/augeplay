import 'package:flutter/material.dart';
import 'package:playauge/core/constants/app_constants.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/core/audio/audio_player_service.dart';
import 'package:playauge/features/discovery/presentation/state/discovery_provider.dart';
import 'package:playauge/features/opportunities/presentation/state/opportunity_provider.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/shared/widgets/custom_card.dart';
import 'package:playauge/shared/widgets/user_avatar.dart';
import 'package:playauge/shared/widgets/availability_badge.dart';
import 'package:playauge/shared/widgets/star_rating.dart';
import 'package:playauge/shared/widgets/state_views.dart';

class DiscoveryScreen extends StatefulWidget {
  final DiscoveryProvider discoveryProvider;
  final OpportunityProvider opportunityProvider;
  final MusicProvider musicProvider;
  final AudioPlayerService audioService;
  final void Function(String userId) onOpenProfile;

  const DiscoveryScreen({
    super.key,
    required this.discoveryProvider,
    required this.opportunityProvider,
    required this.musicProvider,
    required this.audioService,
    required this.onOpenProfile,
  });

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String? selectedCity = widget.discoveryProvider.filter.city;
        String? selectedInstrument = widget.discoveryProvider.filter.instrument;
        bool onlyAvail = widget.discoveryProvider.filter.onlyAvailable;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filtrar Profissionais', style: AppTextStyles.titleMedium),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Filtro: Somente Disponíveis
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Somente disponíveis para trabalho (🟢)', style: AppTextStyles.bodyMedium),
                    value: onlyAvail,
                    activeColor: AppColors.availableGreen,
                    onChanged: (val) {
                      setModalState(() => onlyAvail = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Cidade
                  Text('Cidade', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String?>(
                    value: selectedCity,
                    hint: const Text('Todas as cidades'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Todas as cidades')),
                      DropdownMenuItem(value: 'São Paulo', child: Text('São Paulo - SP')),
                      DropdownMenuItem(value: 'Goiânia', child: Text('Goiânia - GO')),
                      DropdownMenuItem(value: 'Belo Horizonte', child: Text('Belo Horizonte - MG')),
                      DropdownMenuItem(value: 'Rio de Janeiro', child: Text('Rio de Janeiro - RJ')),
                    ],
                    onChanged: (val) => setModalState(() => selectedCity = val),
                  ),
                  const SizedBox(height: 16),

                  // Instrumento
                  Text('Instrumento', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String?>(
                    value: selectedInstrument,
                    hint: const Text('Todos os instrumentos'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todos os instrumentos')),
                      ...AppConstants.commonInstruments.map(
                        (i) => DropdownMenuItem(value: i, child: Text(i)),
                      ),
                    ],
                    onChanged: (val) => setModalState(() => selectedInstrument = val),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.discoveryProvider.clearFilters();
                            Navigator.pop(context);
                          },
                          child: const Text('Limpar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final current = widget.discoveryProvider.filter;
                            widget.discoveryProvider.updateFilter(
                              current.copyWith(
                                city: selectedCity,
                                clearCity: selectedCity == null,
                                instrument: selectedInstrument,
                                clearInstrument: selectedInstrument == null,
                                onlyAvailable: onlyAvail,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Descobrir'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Músicos & Artistas'),
            Tab(text: 'Oportunidades'),
            Tab(text: 'Músicas'),
            Tab(text: 'Composições'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de Busca e Filtro
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (text) => widget.discoveryProvider.updateQuery(text),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome, instrumento, cidade...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                widget.discoveryProvider.updateQuery('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  icon: const Icon(Icons.tune_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: widget.discoveryProvider.filter.hasActiveFilters
                        ? AppColors.primary
                        : AppColors.surfaceElevated,
                    foregroundColor: widget.discoveryProvider.filter.hasActiveFilters
                        ? AppColors.textInverse
                        : AppColors.textPrimary,
                  ),
                  onPressed: _showFilterModal,
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMusiciansTab(),
                _buildOpportunitiesTab(),
                _buildSongsTab(),
                _buildCompositionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusiciansTab() {
    return AnimatedBuilder(
      animation: widget.discoveryProvider,
      builder: (context, _) {
        if (widget.discoveryProvider.isLoading) {
          return const LoadingStateView(message: 'Buscando profissionais...');
        }

        final profiles = widget.discoveryProvider.profiles;
        if (profiles.isEmpty) {
          return EmptyStateView(
            icon: Icons.person_search_rounded,
            title: 'Nenhum músico ou artista encontrado',
            subtitle: 'Tente alterar a cidade, instrumento ou limpar os filtros de busca.',
            actionLabel: 'Limpar Filtros',
            onAction: () {
              _searchController.clear();
              widget.discoveryProvider.clearFilters();
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            final u = profile.user;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomCard(
                onTap: () => widget.onOpenProfile(u.id),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(name: u.displayName, radius: 28, isVerified: u.isVerified),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  u.displayName,
                                  style: AppTextStyles.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              AvailabilityBadge(
                                isAvailable: profile.availability.isAvailable,
                                compact: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.instrumentsFormatted.isNotEmpty
                                ? profile.instrumentsFormatted
                                : u.roles.map((r) => r.shortLabel).join(', '),
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(u.locationFormatted, style: AppTextStyles.bodySmall),
                              const SizedBox(width: 12),
                              StarRating(rating: u.rating, reviewsCount: u.ratingsCount),
                            ],
                          ),
                          if (profile.availability.baseRate != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Cachê base: ${CurrencyFormatter.formatBRL(profile.availability.baseRate!)}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOpportunitiesTab() {
    return AnimatedBuilder(
      animation: widget.opportunityProvider,
      builder: (context, _) {
        final opps = widget.opportunityProvider.opportunities;
        if (opps.isEmpty) {
          return const EmptyStateView(
            icon: Icons.work_outline,
            title: 'Nenhuma oportunidade no momento',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: opps.length,
          itemBuilder: (context, index) {
            final op = opps[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(op.type.label, style: AppTextStyles.badgeText.copyWith(color: AppColors.primary)),
                        if (op.cacheAmount != null)
                          Text(
                            CurrencyFormatter.formatBRL(op.cacheAmount!),
                            style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(op.title, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 4),
                    Text(op.description, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${op.city} - ${op.state} • ${op.genre}', style: AppTextStyles.bodySmall),
                        TextButton(
                          onPressed: () {
                            widget.opportunityProvider.applyToOpportunity(op.id, 'current_user');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Interesse registrado com sucesso! O contratante foi notificado.')),
                            );
                          },
                          child: const Text('TENHO INTERESSE'),
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
    );
  }

  Widget _buildSongsTab() {
    return AnimatedBuilder(
      animation: widget.musicProvider,
      builder: (context, _) {
        final songs = widget.musicProvider.songs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomCard(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
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
                          Text(song.title, style: AppTextStyles.titleSmall),
                          Text('${song.artistName} • ${song.genre}', style: AppTextStyles.bodySmall),
                          Text('Tom: ${song.musicalKey ?? 'N/A'} • ${song.bpm ?? '--'} BPM', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 38),
                      onPressed: () => widget.audioService.playSong(song, queue: songs),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompositionsTab() {
    return AnimatedBuilder(
      animation: widget.musicProvider,
      builder: (context, _) {
        final comps = widget.musicProvider.compositions;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: comps.length,
          itemBuilder: (context, index) {
            final c = comps[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Composição • ${c.genre}', style: AppTextStyles.badgeText.copyWith(color: AppColors.secondaryLight)),
                        if (c.lookingForArtist)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('PROCURA-SE ARTISTA', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(c.title, style: AppTextStyles.titleMedium),
                    Text('Por ${c.composerName}', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 8),
                    Text(
                      c.lyrics,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tom: ${c.musicalKey ?? '--'} • BPM: ${c.bpm ?? '--'}', style: AppTextStyles.bodySmall),
                        TextButton(
                          onPressed: () {
                            widget.musicProvider.toggleInterestInComposition(c.id, 'user_me');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Interesse registrado! Você pode iniciar uma conversa com o compositor.')),
                            );
                          },
                          child: Text('Tenho Interesse (${c.interestedCount})'),
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
    );
  }
}
