import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/core/utils/date_formatter.dart';
import 'package:playauge/core/utils/validators.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';
import 'package:playauge/features/profile/data/repositories/profile_repository.dart';
import 'package:playauge/features/discovery/domain/models/search_filter.dart';
import 'package:playauge/features/discovery/data/repositories/discovery_repository.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';
import 'package:playauge/features/music/data/repositories/music_repository.dart';
import 'package:playauge/features/opportunities/domain/models/opportunity_entity.dart';
import 'package:playauge/features/opportunities/data/repositories/opportunity_repository.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';
import 'package:playauge/features/contracts/data/repositories/contract_repository.dart';
import 'package:playauge/features/rehearsals/domain/models/rehearsal_entity.dart';
import 'package:playauge/features/rehearsals/data/repositories/rehearsal_repository.dart';
import 'package:playauge/features/feed/domain/models/post_entity.dart';
import 'package:playauge/features/feed/data/repositories/feed_repository.dart';
import 'package:playauge/features/chat/domain/models/chat_message_entity.dart';
import 'package:playauge/features/chat/data/repositories/chat_repository.dart';

int totalTests = 0;
int passedTests = 0;
int failedTests = 0;

void testCase(String description, void Function() body) {
  totalTests++;
  try {
    body();
    passedTests++;
    print('  ✓ $description');
  } catch (e, stack) {
    failedTests++;
    print('  ✗ $description');
    print('    Erro: $e');
    print('    Stack: $stack');
  }
}

Future<void> asyncTestCase(String description, Future<void> Function() body) async {
  totalTests++;
  try {
    await body();
    passedTests++;
    print('  ✓ $description');
  } catch (e, stack) {
    failedTests++;
    print('  ✗ $description');
    print('    Erro: $e');
    print('    Stack: $stack');
  }
}

void expectEqual<T>(T actual, T expected, [String? context]) {
  if (actual != expected) {
    throw Exception('Esperado: $expected, obtido: $actual ${context != null ? "($context)" : ""}');
  }
}

void expectTrue(bool condition, [String? context]) {
  if (!condition) {
    throw Exception('Esperado verdadeiro, obtido falso ${context != null ? "($context)" : ""}');
  }
}

Future<void> main() async {
  print('=====================================================');
  print('  SUÍTE DE TESTES AUTOMATIZADOS - PLAYAUGE FLUTTER  ');
  print('=====================================================\n');

  // 1. Core Utils Tests
  print('[1/8] Testando Core Utils & Formatters...');
  testCase('CurrencyFormatter formata valor BRL corretamente', () {
    final res = CurrencyFormatter.formatBRL(650.0);
    expectTrue(res.contains('650'), 'deve conter 650');
    expectTrue(res.contains('R\$'), 'deve conter R\$');
  });

  testCase('CurrencyFormatter calcula faixas de cachê', () {
    expectEqual(CurrencyFormatter.formatCacheRange(null, null), 'Cachê a combinar');
    expectTrue(CurrencyFormatter.formatCacheRange(500, null).contains('A partir de'));
    expectTrue(CurrencyFormatter.formatCacheRange(null, 1000).contains('Até'));
  });

  testCase('DateFormatter formata datas e horários', () {
    final d = DateTime(2026, 10, 20, 19, 30);
    expectEqual(DateFormatter.formatDate(d), '20/10/2026');
    expectEqual(DateFormatter.formatTime(d), '19:30');
  });

  testCase('Validators valida e-mails, senhas e campos obrigatórios', () {
    expectTrue(Validators.validateEmail('') != null);
    expectTrue(Validators.validateEmail('email_invalido') != null);
    expectTrue(Validators.validateEmail('musico@playauge.com') == null);
    expectTrue(Validators.validatePassword('123') != null);
    expectTrue(Validators.validatePassword('123456') == null);
    expectTrue(Validators.validateRequired('', 'Nome') != null);
    expectTrue(Validators.validateRequired('João', 'Nome') == null);
  });

  // 2. Auth & User Domain Tests
  print('\n[2/8] Testando Auth & Entidades de Usuário...');
  testCase('UserRole retorna rótulos adequados e parse de string', () {
    expectEqual(UserRole.artista.shortLabel, 'Artista');
    expectEqual(UserRole.musico.shortLabel, 'Músico');
    expectEqual(UserRole.compositor.shortLabel, 'Compositor');
    expectEqual(UserRole.fromString('artista'), UserRole.artista);
    expectEqual(UserRole.fromString('musico'), UserRole.musico);
  });

  testCase('UserEntity serialização JSON e propriedades derivadas', () {
    const user = UserEntity(
      id: 'u_100',
      name: 'João Carlos',
      stageName: 'João Silva',
      email: 'joao@playauge.com',
      city: 'Goiânia',
      state: 'GO',
      bio: 'Cantor sertanejo',
      roles: [UserRole.artista],
      rating: 4.9,
    );

    expectEqual(user.displayName, 'João Silva');
    expectEqual(user.locationFormatted, 'Goiânia - GO');

    final json = user.toJson();
    final restored = UserEntity.fromJson(json);
    expectEqual(restored.id, 'u_100');
    expectEqual(restored.displayName, 'João Silva');
    expectEqual(restored.roles.first, UserRole.artista);
  });

  await asyncTestCase('AuthRepository login e registro funcionam', () async {
    final repo = AuthRepositoryImpl();
    final logged = await repo.login('joao.silva@playauge.demo', '123456');
    expectEqual(logged.displayName, 'João Silva');

    final registered = await repo.register(
      name: 'Novo Músico',
      stageName: 'Novo Guitarrista',
      email: 'novo@musico.com',
      password: 'senha123',
      city: 'Curitiba',
      state: 'PR',
      bio: 'Guitarrista iniciante na plataforma',
      roles: [UserRole.musico],
    );
    expectEqual(registered.displayName, 'Novo Guitarrista');
    expectEqual(registered.state, 'PR');
  });

  // 3. Profile & Availability Tests
  print('\n[3/8] Testando Perfil & Disponibilidade Profissional...');
  testCase('AvailabilityEntity gerencia datas bloqueadas e disponíveis', () {
    final blockedDate = DateTime(2026, 10, 22);
    final avail = AvailabilityEntity(
      isAvailable: true,
      blockedDates: [blockedDate],
    );

    expectTrue(avail.isAvailableOn(DateTime(2026, 10, 21)), 'deve estar disponível dia 21');
    expectTrue(!avail.isAvailableOn(blockedDate), 'não deve estar disponível dia 22 bloqueado');
  });

  await asyncTestCase('ProfileRepository atualiza disponibilidade', () async {
    final repo = ProfileRepositoryImpl();
    final updated = await repo.updateAvailability(
      'user_pedro_santos',
      const AvailabilityEntity(isAvailable: true, baseRate: 800.0, serviceRadiusKm: 300),
    );
    expectEqual(updated.availability.baseRate, 800.0);
    expectEqual(updated.availability.serviceRadiusKm, 300);
  });

  // 4. Discovery & Multi-criteria Search Tests
  print('\n[4/8] Testando Mecanismo de Busca Inteligente...');
  await asyncTestCase('DiscoveryRepository busca por instrumento e cidade', () async {
    final repo = DiscoveryRepositoryImpl();

    // Busca por baterista em SP
    final bateras = await repo.searchProfiles(const SearchFilter(instrument: 'Bateria', city: 'São Paulo'));
    expectTrue(bateras.isNotEmpty, 'deve encontrar bateristas em SP');
    expectEqual(bateras.first.user.name, 'Marcos Oliveira');

    // Busca por cidade Goiânia
    final goiania = await repo.searchProfiles(const SearchFilter(city: 'Goiânia'));
    expectTrue(goiania.isNotEmpty, 'deve encontrar profissionais em Goiânia');

    // Busca somente disponíveis
    final disponiveis = await repo.searchProfiles(const SearchFilter(onlyAvailable: true));
    for (final p in disponiveis) {
      expectTrue(p.availability.isAvailable);
    }
  });

  // 5. Music & Compositions Tests
  print('\n[5/8] Testando Músicas, Obras e Composições...');
  await asyncTestCase('MusicRepository gerencia catálogo e publicação', () async {
    final repo = MusicRepositoryImpl();

    final initialSongs = await repo.getSongs();
    expectTrue(initialSongs.isNotEmpty);

    final newSong = SongEntity(
      id: 'test_song_99',
      title: 'Som da Madrugada',
      artistId: 'user_1',
      artistName: 'Artista Teste',
      genre: 'Pop',
      audioUrl: 'https://cdn.playauge.com/track.mp3',
      musicalKey: 'A Menor',
      bpm: 128,
      releaseDate: DateTime.now(),
    );

    final published = await repo.publishSong(newSong);
    expectEqual(published.title, 'Som da Madrugada');

    final afterPublish = await repo.getSongs();
    expectEqual(afterPublish.first.title, 'Som da Madrugada');
  });

  await asyncTestCase('CompositionEntity registra interesse de artistas', () async {
    final repo = MusicRepositoryImpl();
    final comps = await repo.getCompositions();
    final targetId = comps.first.id;
    final initialCount = comps.first.interestedCount;

    await repo.toggleInterestInComposition(targetId, 'user_interessado');
    final after = await repo.getCompositions();
    expectEqual(after.first.interestedCount, initialCount + 1);
  });

  // 6. Opportunities & Murals Tests
  print('\n[6/8] Testando Oportunidades & Mural de Vagas...');
  await asyncTestCase('OpportunityRepository criação de vaga e candidatura', () async {
    final repo = OpportunityRepositoryImpl();
    final opps = await repo.getOpportunities();
    final opId = opps.first.id;

    await repo.applyToOpportunity(opId, 'user_candidato_teste');
    final opAtualizada = await repo.getOpportunityById(opId);
    expectTrue(opAtualizada!.interestedUserIds.contains('user_candidato_teste'));
  });

  // 7. Contracts & Booking Flow Tests
  print('\n[7/8] Testando Fluxo de Contratação & Propostas...');
  await asyncTestCase('ContractRepository envio de convite, aceite e negociação', () async {
    final repo = ContractRepositoryImpl();

    final invite = ContractInviteEntity(
      id: 'inv_test_case',
      senderId: 'user_artista',
      senderName: 'João Artista',
      recipientId: 'user_musico',
      recipientName: 'Pedro Músico',
      eventName: 'Show Aniversário',
      eventDate: DateTime(2026, 11, 20),
      eventTime: '21:00',
      eventLocation: 'Clube Central',
      city: 'São Paulo',
      state: 'SP',
      cacheAmount: 700.0,
      createdAt: DateTime.now(),
    );

    await repo.sendInvite(invite);

    // Negociação
    final neg = await repo.respondToInvite(
      inviteId: 'inv_test_case',
      status: ContractStatus.emNegociacao,
      counterOfferAmount: 850.0,
    );
    expectEqual(neg.status, ContractStatus.emNegociacao);
    expectEqual(neg.counterOfferAmount, 850.0);

    // Aceite
    final aceito = await repo.respondToInvite(
      inviteId: 'inv_test_case',
      status: ContractStatus.aceito,
    );
    expectEqual(aceito.status, ContractStatus.aceito);
  });

  // 8. Rehearsals, Feed & Chat Tests
  print('\n[8/8] Testando Ensaios, Repertório, Feed e Mensagens...');
  await asyncTestCase('RehearsalRepository gerencia repertório e presença', () async {
    final repo = RehearsalRepositoryImpl();
    const novaFaixa = RepertoireItem(
      id: 'rep_nova',
      songTitle: 'Sinônimos',
      musicalKey: 'D Maior',
      bpm: 82,
      notes: 'Entrada com violão dedilhado',
    );

    final updated = await repo.addRepertoireItem('reh_1', novaFaixa);
    expectTrue(updated.repertoire.any((r) => r.songTitle == 'Sinônimos'));

    final confirmed = await repo.confirmPresence('reh_1', 'Carlos Teclas');
    expectTrue(confirmed.confirmedParticipantNames.contains('Carlos Teclas'));
  });

  await asyncTestCase('FeedRepository posts e curtidas', () async {
    final repo = FeedRepositoryImpl();
    final posts = await repo.getFeedPosts();
    final targetId = posts.first.id;
    final initialLikes = posts.first.likesCount;

    final liked = await repo.toggleLike(targetId);
    expectEqual(liked.likesCount, initialLikes + 1);
  });

  await asyncTestCase('ChatRepository envio e listagem de mensagens', () async {
    final repo = ChatRepositoryImpl();
    final novaMsg = ChatMessageEntity(
      id: 'msg_teste',
      conversationId: 'conv_pedro',
      senderId: 'user_eu',
      senderName: 'Eu',
      text: 'Olá Pedro, repertório confirmado!',
      timestamp: DateTime.now(),
    );

    await repo.sendMessage(novaMsg);
    final msgs = await repo.getMessages('conv_pedro');
    expectTrue(msgs.any((m) => m.text.contains('repertório confirmado')));
  });

  print('\n=====================================================');
  print('  RESULTADO DA EXECUÇÃO DOS TESTES PLAYAUGE:');
  print('  Total: $totalTests');
  print('  Passaram: $passedTests');
  print('  Falharam: $failedTests');
  print('=====================================================');

  if (failedTests > 0) {
    throw Exception('$failedTests testes falharam!');
  }
}
