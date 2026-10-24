import 'package:flutter/material.dart';
import 'package:playauge/core/audio/audio_player_service.dart';
import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/features/discovery/presentation/state/discovery_provider.dart';
import 'package:playauge/features/opportunities/presentation/state/opportunity_provider.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/features/feed/presentation/state/feed_provider.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/contracts/presentation/state/contract_provider.dart';
import 'package:playauge/features/videos/presentation/state/video_provider.dart';
import 'package:playauge/features/videos/presentation/screens/video_call_screen.dart';
import 'package:playauge/features/videos/data/call_signaling_service.dart';
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
  bool _isIncomingCallModalOpen = false;

  @override
  void initState() {
    super.initState();
    widget.authProvider.addListener(_onStateChanged);
    widget.profileProvider.addListener(_onStateChanged);

    final currentUser = widget.authProvider.currentUser ?? MockData.joaoSilva;
    CallSignalingService().init(currentUser.id);
    CallSignalingService().addListener(_onCallSignalingChanged);
  }

  void _onStateChanged() {
    final currentU = widget.authProvider.currentUser;
    if (currentU != null) {
      CallSignalingService().init(currentU.id);
    }
    if (mounted) setState(() {});
  }

  void _onCallSignalingChanged() {
    if (!mounted) return;
    if (CallSignalingService().hasIncomingCall && !_isIncomingCallModalOpen) {
      _isIncomingCallModalOpen = true;
      _showIncomingCallDialog(CallSignalingService().incomingCallData!);
    } else if (!CallSignalingService().hasIncomingCall && _isIncomingCallModalOpen) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      _isIncomingCallModalOpen = false;
    }
  }

  void _showIncomingCallDialog(Map<String, dynamic> callerData) {
    final callerName = callerData['callerName'] as String? ?? 'Produtor / Músico';
    final callerAvatar = callerData['callerAvatar'] as String? ?? '';
    final callerCity = callerData['callerCity'] as String? ?? 'Brasil';
    final cacheAmount = (callerData['cacheAmount'] as num?)?.toDouble() ?? 800.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColors.surfaceElevated,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.primary, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.ring_volume_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chamada de Audição de Vídeo!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$callerName está te ligando para audição ao vivo',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.surface,
                    backgroundImage: callerAvatar.isNotEmpty ? NetworkImage(callerAvatar) : null,
                    child: callerAvatar.isEmpty
                        ? Text(
                            callerName.isNotEmpty ? callerName[0] : 'U',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    callerCity,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Cachê Proposto: ${CurrencyFormatter.formatBRL(cacheAmount)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.call_end_rounded, size: 18),
                          label: const Text('Recusar', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            _isIncomingCallModalOpen = false;
                            Navigator.pop(dialogCtx);
                            CallSignalingService().rejectIncomingCall();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.call_rounded, size: 18),
                          label: const Text('Atender', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            _isIncomingCallModalOpen = false;
                            Navigator.pop(dialogCtx);
                            CallSignalingService().acceptIncomingCall();

                            final currentU = widget.authProvider.currentUser ?? MockData.pedroSantos;
                            final callerId = callerData['callerId'] as String? ?? '1';
                            final callerUser = MockData.allUsers.firstWhere(
                              (u) => u.id == callerId,
                              orElse: () => UserEntity(
                                id: callerId,
                                name: callerName,
                                stageName: callerName,
                                email: '$callerId@playauge.demo',
                                roles: const [UserRole.produtor],
                                bio: 'Produtor Musical / Artista no PlayAuge',
                                city: callerCity.split(' - ').first,
                                state: callerCity.contains(' - ') ? callerCity.split(' - ').last : 'SP',
                                avatarUrl: callerAvatar,
                              ),
                            );

                            final myProfile = widget.profileProvider.getProfile(currentU.id) ??
                                MockData.profiles.firstWhere(
                                  (p) => p.user.id == currentU.id,
                                  orElse: () => MockData.profiles[1],
                                );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoCallScreen(
                                  callerUser: callerUser,
                                  targetProfile: myProfile,
                                  proposedCache: cacheAmount,
                                  onContractAgreed: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isIncomingCallModalOpen = false;
    });
  }

  @override
  void dispose() {
    CallSignalingService().removeListener(_onCallSignalingChanged);
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
