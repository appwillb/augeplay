# PlayAuge — Rede Social & Profissional para Músicos, Artistas e Compositores

Plataforma mobile completa e profissional desenvolvida em **Flutter**, com **Clean Architecture**, **Repository Pattern** e **State Management** reativo para o mercado da música.

> *"Encontre músicos, encontre oportunidades e faça sua música acontecer em qualquer lugar."*

---

## 📁 1. Estrutura de Pastas (Clean Architecture)

```
playauge/
├── lib/
│   ├── main.dart                                   # Ponto de entrada e Injeção de Dependências
│   ├── core/
│   │   ├── audio/
│   │   │   └── audio_player_service.dart           # Serviço Global de Áudio e MiniPlayer Persistente
│   │   ├── constants/
│   │   │   ├── app_constants.dart                  # Constantes (Gêneros, Instrumentos, UFs)
│   │   │   └── mock_data.dart                      # Dados Fictícios de Demonstração (DEMO DATA)
│   │   ├── errors/
│   │   │   └── failures.dart                       # Classes de Erros de Domínio
│   │   ├── theme/
│   │   │   ├── app_colors.dart                     # Paleta Dark Stage / Studio
│   │   │   ├── app_text_styles.dart                # Tipografia moderna
│   │   │   └── app_theme.dart                      # ThemeData Dark Musical
│   │   └── utils/
│   │       ├── currency_formatter.dart             # Formatação de Cachês em BRL (R$ 650,00)
│   │       ├── date_formatter.dart                 # Formatação de Datas e Horários
│   │       └── validators.dart                     # Validações de Formulários
│   ├── features/
│   │   ├── auth/                                   # Login, Cadastro Multi-Role
│   │   ├── profile/                                # Perfil Profissional & Disponibilidade (🟢 / ⚪)
│   │   ├── discovery/                              # Busca Multi-critério por Cidade, Instrumento, Data
│   │   ├── opportunities/                          # Mural de Vagas para Shows e Gravações
│   │   ├── contracts/                              # Fluxo de Contratação: Aceitar / Recusar / Negociar
│   │   ├── rehearsals/                             # Ensaios de Banda & Repertório com Tom e BPM
│   │   ├── music/                                  # Catálogo de Músicas e Composições Inéditas
│   │   ├── feed/                                   # Feed Social Musical com Curtidas e Compartilhamento
│   │   ├── chat/                                   # Mensagens em Tempo Real
│   │   └── home/                                   # Dashboard Inicial & Navegação Inferior
│   └── shared/
│       └── widgets/                                # Componentes reutilizáveis (MiniPlayer, Badges, Cards)
└── test/
    ├── run_all_tests.dart                          # Executável da Suíte de Testes Automatizados
    └── features/                                   # Testes unitários de cada módulo
```

---

## 📦 2. Dependências

Definidas em `pubspec.yaml`:
- `flutter`: Framework UI multiplataforma
- `intl`: Internacionalização e utilitários
- `uuid`: Geração de identificadores únicos
- `flutter_test` / `test`: Execução de testes automatizados

---

## 🏛️ 3. Arquitetura

O projeto adota **Clean Architecture modular**:
- **Domain Layer**: Entidades de negócio puras (`UserEntity`, `ProfileEntity`, `SongEntity`, `OpportunityEntity`, `ContractInviteEntity`, `RehearsalEntity`), enums (`UserRole`, `ContractStatus`) e contratos de repositório.
- **Data Layer**: Implementações de repositório (`AuthRepositoryImpl`, `DiscoveryRepositoryImpl`, `ContractRepositoryImpl`, etc.) preparadas para consumo de APIs REST / GraphQL / Supabase / PostgreSQL.
- **Presentation Layer**: Telas modulares alimentadas por `ChangeNotifier` / Provider com estados previsíveis (`isLoading`, `errorMessage`, `EmptyStateView`, `ErrorStateView`).

---

## 🗄️ 4. Modelagem de Banco de Dados (PostgreSQL / Relacional)

Para a infraestrutura de backend em produção:
- `users`: `id`, `name`, `stage_name`, `email`, `city`, `state`, `bio`, `rating`, `created_at`
- `user_roles`: `user_id`, `role` (artista, musico, compositor, produtor, profissional)
- `profiles`: `user_id`, `years_experience`, `base_rate`, `service_radius_km`, `states_served`
- `musician_instruments`: `profile_id`, `instrument_name`
- `musician_genres`: `profile_id`, `genre_name`
- `availability_blocks`: `user_id`, `blocked_date`, `reason`
- `songs`: `id`, `artist_id`, `title`, `audio_url`, `musical_key`, `bpm`, `lyrics`, `is_public`
- `compositions`: `id`, `composer_id`, `title`, `demo_audio_url`, `looking_for_artist`, `looking_for_producer`
- `opportunities`: `id`, `creator_id`, `title`, `type`, `instrument`, `city`, `event_date`, `cache_amount`
- `contract_invites`: `id`, `sender_id`, `recipient_id`, `event_name`, `event_date`, `cache_amount`, `status`
- `rehearsals`: `id`, `title`, `studio_name`, `date`, `time`, `location_address`
- `repertoire_items`: `rehearsal_id`, `song_title`, `musical_key`, `bpm`, `notes`
- `chat_messages`: `id`, `conversation_id`, `sender_id`, `text`, `timestamp`, `is_read`

---

## 🧪 5. Execução dos Testes Automatizados

Para executar os 17 testes automatizados de domínio, repositórios e utilitários:

```bash
dart test/run_all_tests.dart
```

Resultado verificado:
```
✓ CurrencyFormatter formata valor BRL corretamente
✓ CurrencyFormatter calcula faixas de cachê
✓ DateFormatter formata datas e horários
✓ Validators valida e-mails, senhas e campos obrigatórios
✓ UserRole retorna rótulos adequados e parse de string
✓ UserEntity serialização JSON e propriedades derivadas
✓ AuthRepository login e registro funcionam
✓ AvailabilityEntity gerencia datas bloqueadas e disponíveis
✓ ProfileRepository atualiza disponibilidade
✓ DiscoveryRepository busca por instrumento e cidade
✓ MusicRepository gerencia catálogo e publicação
✓ CompositionEntity registra interesse de artistas
✓ OpportunityRepository criação de vaga e candidatura
✓ ContractRepository envio de convite, aceite e negociação
✓ RehearsalRepository gerencia repertório e presença
✓ FeedRepository posts e curtidas
✓ ChatRepository envio e listagem de mensagens
Total: 17 | Passaram: 17 | Falharam: 0
```
