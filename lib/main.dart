import 'package:flutter/material.dart';
import 'package:playauge/core/audio/audio_player_service.dart';
import 'package:playauge/core/theme/app_theme.dart';
import 'package:playauge/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:playauge/features/auth/presentation/screens/login_screen.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/features/chat/data/repositories/chat_repository.dart';
import 'package:playauge/features/contracts/data/repositories/contract_repository.dart';
import 'package:playauge/features/contracts/presentation/state/contract_provider.dart';
import 'package:playauge/features/discovery/data/repositories/discovery_repository.dart';
import 'package:playauge/features/discovery/presentation/state/discovery_provider.dart';
import 'package:playauge/features/feed/data/repositories/feed_repository.dart';
import 'package:playauge/features/feed/presentation/state/feed_provider.dart';
import 'package:playauge/features/home/presentation/screens/main_navigation_screen.dart';
import 'package:playauge/features/music/data/repositories/music_repository.dart';
import 'package:playauge/features/music/presentation/state/music_provider.dart';
import 'package:playauge/features/opportunities/data/repositories/opportunity_repository.dart';
import 'package:playauge/features/opportunities/presentation/state/opportunity_provider.dart';
import 'package:playauge/features/profile/data/repositories/profile_repository.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';
import 'package:playauge/features/videos/data/repositories/video_repository.dart';
import 'package:playauge/features/videos/presentation/state/video_provider.dart';
import 'package:playauge/features/rehearsals/data/repositories/rehearsal_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PlayAugeApp());
}

/// Aplicativo Principal PlayAuge (GPSMusic)
class PlayAugeApp extends StatefulWidget {
  const PlayAugeApp({super.key});

  @override
  State<PlayAugeApp> createState() => _PlayAugeAppState();
}

class _PlayAugeAppState extends State<PlayAugeApp> {
  // Repositórios
  final _authRepository = AuthRepositoryImpl();
  final _profileRepository = ProfileRepositoryImpl();
  final _discoveryRepository = DiscoveryRepositoryImpl();
  final _musicRepository = MusicRepositoryImpl();
  final _opportunityRepository = OpportunityRepositoryImpl();
  final _contractRepository = ContractRepositoryImpl();
  final _rehearsalRepository = RehearsalRepositoryImpl();
  final _feedRepository = FeedRepositoryImpl();
  final _chatRepository = ChatRepositoryImpl();
  final _videoRepository = VideoRepositoryImpl();

  // Serviços
  final _audioService = AudioPlayerService();

  // Estados Globais / Notifiers
  late final AuthProvider _authProvider;
  late final ProfileProvider _profileProvider;
  late final DiscoveryProvider _discoveryProvider;
  late final MusicProvider _musicProvider;
  late final OpportunityProvider _opportunityProvider;
  late final ContractProvider _contractProvider;
  late final FeedProvider _feedProvider;
  late final VideoProvider _videoProvider;

  bool _isLoggedIn = true; // Sessão demonstrativa ativa por padrão

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(_authRepository);
    _profileProvider = ProfileProvider(_profileRepository);
    _discoveryProvider = DiscoveryProvider(_discoveryRepository);
    _musicProvider = MusicProvider(_musicRepository);
    _opportunityProvider = OpportunityProvider(_opportunityRepository);
    _contractProvider = ContractProvider(_contractRepository);
    _feedProvider = FeedProvider(_feedRepository);
    _videoProvider = VideoProvider(_videoRepository);

    // Sincroniza estado de autenticação para Login / Logout automático
    _isLoggedIn = _authProvider.isAuthenticated;
    _authProvider.addListener(_handleAuthChange);

    // Carrega convites para o usuário ativo
    _contractProvider.loadInvites('user_pedro_santos');
  }

  void _handleAuthChange() {
    if (mounted) {
      setState(() {
        _isLoggedIn = _authProvider.isAuthenticated;
      });
    }
  }

  @override
  void dispose() {
    _authProvider.removeListener(_handleAuthChange);
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPSMusic - Rede Profissional para Músicos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _isLoggedIn
          ? MainNavigationScreen(
              authProvider: _authProvider,
              discoveryProvider: _discoveryProvider,
              opportunityProvider: _opportunityProvider,
              musicProvider: _musicProvider,
              feedProvider: _feedProvider,
              profileProvider: _profileProvider,
              contractProvider: _contractProvider,
              videoProvider: _videoProvider,
              rehearsalRepository: _rehearsalRepository,
              chatRepository: _chatRepository,
              audioService: _audioService,
            )
          : LoginScreen(
              authProvider: _authProvider,
              onLoginSuccess: () => setState(() => _isLoggedIn = true),
            ),
    );
  }
}
