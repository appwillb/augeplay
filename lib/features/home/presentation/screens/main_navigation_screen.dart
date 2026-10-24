import 'package:flutter/material.dart';
import 'package:playauge/core/audio/audio_player_service.dart';
import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/features/discovery/presentation/state/discovery_provider.dart';
import 'package:playauge/features/opportunities/presentation/state/opportunity_provider.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/features/feed/presentation/state/feed_provider.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/contracts/presentation/state/contract_provider.dart';
import 'package:playauge/features/videos/presentation/state/video_provider.dart';
import 'package:playauge/features/rehearsals/data/repositories/rehearsal_repository.dart';
import 'package:playauge/features/chat/data/repositories/chat_repository.dart';
import 'package:playauge/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:playauge/features/discovery/presentation/screens/discovery_screen.dart';
import 'package:playauge/features/profile/presentation/screens/profile_screen.dart';
import 'package:playauge/features/feed/presentation/screens/feed_screen.dart';
import 'package:playauge/features/chat/presentation/screens/chat_screen.dart';
import 'package:playauge/features/contracts/presentation/screens/send_invite_screen.dart';
import 'package:playauge/features/contracts/presentation/screens/invitations_screen.dart';
import 'package:playauge/features/rehearsals/presentation/screens/rehearsals_screen.dart';
import 'package:playauge/features/music/presentation/screens/upload_song_screen.dart';
import 'package:playauge/shared/widgets/mini_player_widget.dart';

class MainNavigationScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final DiscoveryProvider discoveryProvider;
  final OpportunityProvider opportunityProvider;
  final MusicProvider musicProvider;
  final FeedProvider feedProvider;
  final ProfileProvider profileProvider;
  final ContractProvider contractProvider;
  final VideoProvider videoProvider;
  final RehearsalRepository rehearsalRepository;
  final ChatRepository chatRepository;
  final AudioPlayerService audioService;

  const MainNavigationScreen({
    super.key,
    required this.authProvider,
    required this.discoveryProvider,
    required this.opportunityProvider,
    required this.musicProvider,
    required this.feedProvider,
    required this.profileProvider,
    required this.contractProvider,
    required this.videoProvider,
    required this.rehearsalRepository,
    required this.chatRepository,
    required this.audioService,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.authProvider.addListener(_onStateChanged);
    widget.profileProvider.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.authProvider.removeListener(_onStateChanged);
    widget.profileProvider.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onOpenProfile(String userId) {
    final profile = widget.profileProvider.getProfile(userId) ??
        MockData.profiles.firstWhere(
          (p) => p.user.id == userId,
          orElse: () => MockData.profiles.first,
        );

    final currentUser = widget.authProvider.currentUser ?? MockData.joaoSilva;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          profile: profile,
          profileProvider: widget.profileProvider,
          videoProvider: widget.videoProvider,
          currentUser: currentUser,
          authProvider: widget.authProvider,
          isMyProfile: widget.authProvider.currentUser?.id == userId,
          onLogout: () async {
            await widget.authProvider.logout();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          onInviteForGig: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SendInviteScreen(
                  currentUser: currentUser,
                  recipientUser: profile.user,
                  contractProvider: widget.contractProvider,
                ),
              ),
            );
          },
          onChat: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chatRepository: widget.chatRepository,
                  currentUserId: currentUser.id,
                  currentUserName: currentUser.displayName,
                  recipientName: profile.user.displayName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPublishModal() {
    final currentUser = widget.authProvider.currentUser ?? MockData.joaoSilva;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('O que você deseja publicar ou enviar?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.cloud_upload_rounded, color: AppColors.primary),
                  title: const Text('Enviar Música & Tocar no Player'),
                  subtitle: const Text('Upload de MP3/WAV com streaming contínuo no app'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UploadSongScreen(
                          currentUser: currentUser,
                          musicProvider: widget.musicProvider,
                          audioService: widget.audioService,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline, color: AppColors.secondary),
                  title: const Text('Criar Oportunidade / Vaga para Show'),
                  subtitle: const Text('Encontre bateristas, guitarristas ou técnicos na região'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: const Text('Publicar Vaga de Trabalho')),
                          body: const Center(child: Text('Formulário de Vaga Disponível')),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event_note, color: AppColors.success),
                  title: const Text('Organizar Ensaio da Banda'),
                  subtitle: const Text('Defina data, local, repertório, afinação e BPM'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RehearsalsScreen(
                          rehearsalRepository: widget.rehearsalRepository,
                          currentUserName: currentUser.displayName,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_outlined, color: AppColors.primaryLight),
                  title: const Text('Ver Meus Convites e Cachês'),
                  subtitle: const Text('Acompanhe propostas recebidas e negociações'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvitationsScreen(
                          contractProvider: widget.contractProvider,
                          currentUserId: currentUser.id,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.authProvider.currentUser ?? MockData.joaoSilva;
    final myProfile = widget.profileProvider.getProfile(currentUser.id) ??
        MockData.profiles.firstWhere(
          (p) => p.user.id == currentUser.id,
          orElse: () => ProfileEntity(user: currentUser),
        );

    final screens = [
      HomeDashboardScreen(
        authProvider: widget.authProvider,
        discoveryProvider: widget.discoveryProvider,
        opportunityProvider: widget.opportunityProvider,
        musicProvider: widget.musicProvider,
        audioService: widget.audioService,
        onNavigateTab: (tab) => setState(() => _currentIndex = tab),
        onOpenProfile: _onOpenProfile,
      ),
      DiscoveryScreen(
        discoveryProvider: widget.discoveryProvider,
        opportunityProvider: widget.opportunityProvider,
        musicProvider: widget.musicProvider,
        audioService: widget.audioService,
        onOpenProfile: _onOpenProfile,
      ),
      FeedScreen(
        feedProvider: widget.feedProvider,
        currentUser: currentUser,
        onOpenProfile: _onOpenProfile,
      ),
      ChatScreen(
        chatRepository: widget.chatRepository,
        currentUserId: currentUser.id,
        currentUserName: currentUser.displayName,
      ),
      ProfileScreen(
        key: ValueKey('my_profile_${currentUser.id}'),
        profile: myProfile,
        profileProvider: widget.profileProvider,
        videoProvider: widget.videoProvider,
        currentUser: currentUser,
        authProvider: widget.authProvider,
        isMyProfile: true,
        onLogout: () async {
          await widget.authProvider.logout();
        },
        onInviteForGig: () {},
        onChat: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini-player persistente em qualquer tela
          MiniPlayerWidget(playerService: widget.audioService),

          // Barra de Navegação Inferior
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 2 && _currentIndex == 2) {
                _showPublishModal();
              } else {
                setState(() => _currentIndex = index);
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Descobrir',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dynamic_feed_rounded),
                label: 'Mural',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                label: 'Mensagens',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main_add_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        onPressed: _showPublishModal,
        tooltip: 'Enviar Música ou Publicar',
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}
