import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';
import 'package:playauge/features/profile/domain/models/availability_entity.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';
import 'package:playauge/features/opportunities/domain/models/opportunity_entity.dart';
import 'package:playauge/features/feed/domain/models/post_entity.dart';
import 'package:playauge/features/contracts/domain/models/contract_invite_entity.dart';
import 'package:playauge/features/rehearsals/domain/models/rehearsal_entity.dart';
import 'package:playauge/features/notifications/domain/models/notification_entity.dart';

/// DADOS DE DEMONSTRAÇÃO (DEMO DATA)
/// Separados explicitamente da camada de dados reais / APIs.
class MockData {
  // 1. Usuários Fictícios
  static final UserEntity joaoSilva = UserEntity(
    id: 'user_joao_silva',
    name: 'João Silva',
    stageName: 'João Silva',
    email: 'joao.silva@playauge.demo',
    city: 'Goiânia',
    state: 'GO',
    bio: 'Cantor profissional de Sertanejo e Pop há 10 anos. Realizando turnês pelo Centro-Oeste e Sudeste.',
    roles: const [UserRole.artista],
    rating: 4.9,
    ratingsCount: 38,
    followersCount: 12400,
    followingCount: 320,
    isVerified: true,
  );

  static final UserEntity pedroSantos = UserEntity(
    id: 'user_pedro_santos',
    name: 'Pedro Santos',
    stageName: 'Pedro Guitar',
    email: 'pedro.santos@playauge.demo',
    city: 'São Paulo',
    state: 'SP',
    bio: 'Guitarrista e violonista especializado em Sertanejo, Pop e Rock. Equipamento de ponta, pontualidade e leitura de cifra.',
    roles: const [UserRole.musico],
    rating: 5.0,
    ratingsCount: 52,
    followersCount: 4500,
    followingCount: 210,
    isVerified: true,
  );

  static final UserEntity marcosOliveira = UserEntity(
    id: 'user_marcos_oliveira',
    name: 'Marcos Oliveira',
    stageName: 'Marcos Batera',
    email: 'marcos.batera@playauge.demo',
    city: 'São Paulo',
    state: 'SP',
    bio: 'Baterista com 12 anos de estrada. Experiência com cliques, stems, shows grandes e gravação em estúdio.',
    roles: const [UserRole.musico],
    rating: 4.9,
    ratingsCount: 46,
    followersCount: 3800,
    followingCount: 195,
    isVerified: true,
  );

  static final UserEntity carlosSouza = UserEntity(
    id: 'user_carlos_souza',
    name: 'Carlos Souza',
    stageName: 'Carlos Teclas',
    email: 'carlos.teclas@playauge.demo',
    city: 'Belo Horizonte',
    state: 'MG',
    bio: 'Tecladista, pianista e arranjador. Síntese analógica, samplers e arranjos de metais e cordas.',
    roles: const [UserRole.musico, UserRole.produtor],
    rating: 4.8,
    ratingsCount: 29,
    followersCount: 2900,
    followingCount: 150,
  );

  static final UserEntity anaMartins = UserEntity(
    id: 'user_ana_martins',
    name: 'Ana Martins',
    stageName: 'Ana Martins Composições',
    email: 'ana.martins@playauge.demo',
    city: 'Rio de Janeiro',
    state: 'RJ',
    bio: 'Compositora com mais de 30 músicas gravadas no cenário Sertanejo e Pop. Procurando parcerias com cantores e bandas em ascensão.',
    roles: const [UserRole.compositor],
    rating: 5.0,
    ratingsCount: 19,
    followersCount: 8100,
    followingCount: 400,
    isVerified: true,
  );

  static final UserEntity bandaHorizonte = UserEntity(
    id: 'user_banda_horizonte',
    name: 'Banda Horizonte',
    stageName: 'Banda Horizonte',
    email: 'contato@bandahorizonte.demo',
    city: 'Goiânia',
    state: 'GO',
    bio: 'Banda de Pop Rock e Sertanejo Universitário. Disponível para festivais, eventos corporativos e casamentos.',
    roles: const [UserRole.artista],
    rating: 4.9,
    ratingsCount: 64,
    followersCount: 18500,
    followingCount: 120,
    isVerified: true,
  );

  static List<UserEntity> get allUsers => [
        joaoSilva,
        pedroSantos,
        marcosOliveira,
        carlosSouza,
        anaMartins,
        bandaHorizonte,
      ];

  // 2. Perfis Profissionais
  static final List<ProfileEntity> profiles = [
    ProfileEntity(
      user: joaoSilva,
      instruments: const ['Vocal / Cantor', 'Violão'],
      genres: const ['Sertanejo', 'Pop', 'Acústico'],
      yearsOfExperience: 10,
      availability: AvailabilityEntity(
        isAvailable: true,
        baseRate: 3500.0,
        serviceRadiusKm: 500,
        statesServed: const ['GO', 'SP', 'MG', 'DF'],
      ),
      photoUrls: const [
        'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
      ],
    ),
    ProfileEntity(
      user: pedroSantos,
      instruments: const ['Guitarra', 'Violão'],
      genres: const ['Sertanejo', 'Pop', 'Rock'],
      yearsOfExperience: 8,
      availability: AvailabilityEntity(
        isAvailable: true,
        baseRate: 650.0,
        serviceRadiusKm: 250,
        statesServed: const ['SP', 'MG', 'RJ', 'PR'],
        notes: 'Equipamento valvulado, in-ear sem fio e transporte próprio.',
      ),
    ),
    ProfileEntity(
      user: marcosOliveira,
      instruments: const ['Bateria', 'Percussão'],
      genres: const ['Sertanejo', 'Pop', 'Gospel'],
      yearsOfExperience: 12,
      availability: AvailabilityEntity(
        isAvailable: true,
        baseRate: 700.0,
        serviceRadiusKm: 200,
        statesServed: const ['SP', 'RJ', 'MG'],
        notes: 'Bateria acústica completa e pad eletrônico SPD-SX.',
      ),
    ),
    ProfileEntity(
      user: carlosSouza,
      instruments: const ['Teclado / Piano', 'Sintetizador'],
      genres: const ['Pop', 'Sertanejo', 'MPB', 'Jazz / Blues'],
      yearsOfExperience: 11,
      availability: AvailabilityEntity(
        isAvailable: true,
        baseRate: 600.0,
        serviceRadiusKm: 150,
        statesServed: const ['MG', 'SP', 'RJ'],
      ),
    ),
    ProfileEntity(
      user: anaMartins,
      instruments: const ['Violão', 'Piano'],
      genres: const ['Sertanejo', 'Pop', 'MPB'],
      yearsOfExperience: 6,
      availability: AvailabilityEntity(
        isAvailable: true,
        notes: 'Disponível para audições de novas composições e sessões de co-writing.',
      ),
    ),
    ProfileEntity(
      user: bandaHorizonte,
      instruments: const ['Voz', 'Guitarra', 'Baixo', 'Bateria', 'Teclado'],
      genres: const ['Pop Rock', 'Sertanejo'],
      yearsOfExperience: 5,
      bandMemberNames: const ['Lucas (Vocal)', 'Rafael (Guitarra)', 'Bruno (Baixo)', 'Mateus (Bateria)'],
      availability: AvailabilityEntity(
        isAvailable: true,
        baseRate: 6000.0,
        serviceRadiusKm: 600,
        statesServed: const ['GO', 'SP', 'MG', 'DF', 'MS'],
      ),
    ),
  ];

  // 3. Músicas Fictícias
  static final List<SongEntity> songs = [
    SongEntity(
      id: 'song_1',
      title: 'Estrada do Destino',
      artistId: 'user_joao_silva',
      artistName: 'João Silva',
      composerName: 'Ana Martins',
      genre: 'Sertanejo',
      audioUrl: 'https://example.com/audio/estrada_do_destino.mp3',
      musicalKey: 'G Maior',
      bpm: 118,
      releaseDate: DateTime.now().subtract(const Duration(days: 14)),
      playCount: 14500,
      likesCount: 1280,
    ),
    SongEntity(
      id: 'song_2',
      title: 'Noite Paulistana',
      artistId: 'user_banda_horizonte',
      artistName: 'Banda Horizonte',
      genre: 'Pop Rock',
      audioUrl: 'https://example.com/audio/noite_paulistana.mp3',
      musicalKey: 'E Menor',
      bpm: 124,
      releaseDate: DateTime.now().subtract(const Duration(days: 30)),
      playCount: 28900,
      likesCount: 2430,
    ),
  ];

  // 4. Composições Fictícias
  static final List<CompositionEntity> compositions = [
    CompositionEntity(
      id: 'comp_1',
      title: 'Madrugada Fria',
      composerId: 'user_ana_martins',
      composerName: 'Ana Martins',
      lyrics: '''
[Verso 1]
O relógio marca três da manhã
A cidade dorme e eu pensando em você
O rádio toca uma canção qualquer
Que me faz lembrar do que não pôde ser...

[Refrão]
Madrugada fria, coração em brasa
Toda vez que você some, meu mundo desaba
Vem dizer que foi engano, vem cuidar de mim
Antes que essa noite tenha o nosso fim.
''',
      genre: 'Sertanejo',
      musicalKey: 'D Maior',
      bpm: 72,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      lookingForArtist: true,
      lookingForProducer: true,
      interestedCount: 14,
    ),
    CompositionEntity(
      id: 'comp_2',
      title: 'Acordes Livres',
      composerId: 'user_ana_martins',
      composerName: 'Ana Martins',
      lyrics: '''
Soltos no vento como o som do violão
Voando alto acima da multidão...
''',
      genre: 'MPB / Pop',
      musicalKey: 'A Menor',
      bpm: 95,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      lookingForArtist: true,
      interestedCount: 8,
    ),
  ];

  // 5. Oportunidades Fictícias
  static final List<OpportunityEntity> opportunities = [
    OpportunityEntity(
      id: 'op_1',
      title: 'Procura-se Baterista para Show em São Paulo',
      creatorId: 'user_joao_silva',
      creatorName: 'João Silva',
      type: OpportunityType.show,
      instrumentNeeded: 'Bateria',
      city: 'São Paulo',
      state: 'SP',
      eventDate: DateTime.now().add(const Duration(days: 15)),
      genre: 'Sertanejo',
      cacheAmount: 600.0,
      description: 'Artista em turnê procura baterista experiente para show no Villa Country. Necessário tocar com clique e ter transporte.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    OpportunityEntity(
      id: 'op_2',
      title: 'Guitarrista Base e Solo para Gravação de DVD',
      creatorId: 'user_banda_horizonte',
      creatorName: 'Banda Horizonte',
      type: OpportunityType.gravacao,
      instrumentNeeded: 'Guitarra',
      city: 'Goiânia',
      state: 'GO',
      eventDate: DateTime.now().add(const Duration(days: 22)),
      genre: 'Pop Rock',
      cacheAmount: 1200.0,
      description: 'Gravação ao vivo de 8 faixas inéditas. Forneceremos repertório com stems e tablaturas.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    OpportunityEntity(
      id: 'op_3',
      title: 'Tecladista / Sanfoneiro para Turnê Sul de Minas',
      creatorId: 'user_joao_silva',
      creatorName: 'João Silva',
      type: OpportunityType.turne,
      instrumentNeeded: 'Teclado / Sanfona',
      city: 'Belo Horizonte',
      state: 'MG',
      eventDate: DateTime.now().add(const Duration(days: 30)),
      genre: 'Sertanejo',
      cacheAmount: 2400.0,
      description: 'Três datas consecutivas (Sexta, Sábado e Domingo). Cachê total com hotel e van inclusos.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // 6. Publicações do Feed
  static final List<PostEntity> feedPosts = [
    PostEntity(
      id: 'post_1',
      authorId: 'user_joao_silva',
      authorName: 'João Silva',
      authorRole: 'Cantor Sertanejo',
      authorLocation: 'Goiânia - GO',
      content: 'Passagem de som finalizada com sucesso! Alô São Paulo, hoje à noite nos vemos no palco. E já estamos montando a equipe para os próximos shows no interior paulista!',
      type: PostType.texto,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 240,
      commentsCount: 31,
      sharesCount: 12,
    ),
    PostEntity(
      id: 'post_2',
      authorId: 'user_pedro_santos',
      authorName: 'Pedro Santos',
      authorRole: 'Guitarrista',
      authorLocation: 'São Paulo - SP',
      content: 'Agenda da semana aberta! Disponível para freelance nas noites de quinta, sexta e domingo em SP e Grande SP. Equipamento pronto e fone estéreo.',
      type: PostType.texto,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 98,
      commentsCount: 14,
      sharesCount: 5,
    ),
    PostEntity(
      id: 'post_3',
      authorId: 'user_ana_martins',
      authorName: 'Ana Martins',
      authorRole: 'Compositora',
      authorLocation: 'Rio de Janeiro - RJ',
      content: 'Acabei de liberar uma composição inédita na plataforma: "Madrugada Fria"! Quem aí do Sertanejo / Pop procura uma moda marcante para seu próximo repertório? Dê um play na demo!',
      type: PostType.composicao,
      attachedSongTitle: 'Madrugada Fria (Demo)',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 184,
      commentsCount: 27,
      sharesCount: 19,
    ),
  ];

  // 7. Convites de Trabalho
  static final List<ContractInviteEntity> invites = [
    ContractInviteEntity(
      id: 'inv_1',
      senderId: 'user_joao_silva',
      senderName: 'João Silva',
      recipientId: 'user_pedro_santos',
      recipientName: 'Pedro Santos',
      eventName: 'Show Arena Sertaneja',
      eventDate: DateTime.now().add(const Duration(days: 10)),
      eventTime: '21:00',
      eventLocation: 'Espaço Hall, São Paulo',
      city: 'São Paulo',
      state: 'SP',
      cacheAmount: 650.0,
      notes: 'Passagem de som às 17h. Jantar no camarim incluso.',
      status: ContractStatus.pendente,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  // 8. Ensaios
  static final List<RehearsalEntity> rehearsals = [
    RehearsalEntity(
      id: 'reh_1',
      title: 'Ensaio Geral — Show São Paulo',
      bandOrArtistName: 'João Silva Band',
      date: DateTime.now().add(const Duration(days: 8)),
      time: '19:00',
      studioName: 'Estúdio Gravasom XYZ',
      locationAddress: 'Rua Augusta, 1200 - Consolação, SP',
      participantNames: const ['João Silva', 'Pedro Santos', 'Marcos Oliveira', 'Carlos Souza'],
      confirmedParticipantNames: const ['Pedro Santos', 'Carlos Souza'],
      notes: 'Passar as 18 músicas do setlist novo, com foco nas transições.',
      repertoire: const [
        RepertoireItem(
          id: 'rep_1',
          songTitle: 'Estrada do Destino',
          musicalKey: 'G Maior',
          bpm: 118,
          notes: 'Solo de guitarra na segunda estrofe.',
        ),
        RepertoireItem(
          id: 'rep_2',
          songTitle: 'Evidências',
          musicalKey: 'E Maior',
          bpm: 96,
          notes: 'Atenção para modulação no refrão final.',
        ),
      ],
    ),
  ];

  // 9. Notificações
  static final List<NotificationEntity> notifications = [
    NotificationEntity(
      id: 'notif_1',
      type: NotificationType.conviteShow,
      title: 'Novo Convite para Show',
      message: 'João Silva convidou você para o Show Arena Sertaneja em São Paulo com cachê de R\$ 650,00.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    NotificationEntity(
      id: 'notif_2',
      type: NotificationType.interesseOportunidade,
      title: 'Interesse na sua vaga',
      message: 'Marcos Batera demonstrou interesse na oportunidade "Procura-se Baterista".',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationEntity(
      id: 'notif_3',
      type: NotificationType.novoSeguidor,
      title: 'Novo Seguidor',
      message: 'Ana Martins começou a seguir seu perfil profissional.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];
}
