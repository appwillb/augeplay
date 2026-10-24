/// Tipos de Oportunidades Musicais
enum OpportunityType {
  procuroMusico,
  procuroCantor,
  procuroCompositor,
  procuroProdutor,
  procuroBanda,
  procuroTecnico,
  show,
  gravacao,
  turne,
  ensaio,
  parceriaMusical,
  outro;

  String get label {
    switch (this) {
      case OpportunityType.procuroMusico:
        return 'Procuro Músico';
      case OpportunityType.procuroCantor:
        return 'Procuro Cantor(a)';
      case OpportunityType.procuroCompositor:
        return 'Procuro Compositor';
      case OpportunityType.procuroProdutor:
        return 'Procuro Produtor Musical';
      case OpportunityType.procuroBanda:
        return 'Procuro Banda';
      case OpportunityType.procuroTecnico:
        return 'Procuro Técnico / Roadie';
      case OpportunityType.show:
        return 'Vaga para Show';
      case OpportunityType.gravacao:
        return 'Sessão de Gravação';
      case OpportunityType.turne:
        return 'Vaga para Turnê';
      case OpportunityType.ensaio:
        return 'Ensaio Remunerado';
      case OpportunityType.parceriaMusical:
        return 'Parceria Musical';
      case OpportunityType.outro:
        return 'Oportunidade Geral';
    }
  }
}

/// Entidade de Oportunidade / Vaga Musical
class OpportunityEntity {
  final String id;
  final String title;
  final String creatorId;
  final String creatorName;
  final String? creatorAvatarUrl;
  final OpportunityType type;
  final String instrumentNeeded;
  final String city;
  final String state;
  final DateTime eventDate;
  final String genre;
  final double? cacheAmount; // Ex: R$ 600,00
  final String description;
  final DateTime createdAt;
  final List<String> interestedUserIds; // Usuários que clicaram em "Tenho Interesse"
  final bool isOpen;

  const OpportunityEntity({
    required this.id,
    required this.title,
    required this.creatorId,
    required this.creatorName,
    this.creatorAvatarUrl,
    required this.type,
    required this.instrumentNeeded,
    required this.city,
    required this.state,
    required this.eventDate,
    required this.genre,
    this.cacheAmount,
    required this.description,
    required this.createdAt,
    this.interestedUserIds = const [],
    this.isOpen = true,
  });

  String get locationFormatted => '$city - $state';

  OpportunityEntity copyWith({
    String? id,
    String? title,
    String? creatorId,
    String? creatorName,
    String? creatorAvatarUrl,
    OpportunityType? type,
    String? instrumentNeeded,
    String? city,
    String? state,
    DateTime? eventDate,
    String? genre,
    double? cacheAmount,
    String? description,
    DateTime? createdAt,
    List<String>? interestedUserIds,
    bool? isOpen,
  }) {
    return OpportunityEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
      type: type ?? this.type,
      instrumentNeeded: instrumentNeeded ?? this.instrumentNeeded,
      city: city ?? this.city,
      state: state ?? this.state,
      eventDate: eventDate ?? this.eventDate,
      genre: genre ?? this.genre,
      cacheAmount: cacheAmount ?? this.cacheAmount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      interestedUserIds: interestedUserIds ?? this.interestedUserIds,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorAvatarUrl': creatorAvatarUrl,
      'type': type.name,
      'instrumentNeeded': instrumentNeeded,
      'city': city,
      'state': state,
      'eventDate': eventDate.toIso8601String(),
      'genre': genre,
      'cacheAmount': cacheAmount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'interestedUserIds': interestedUserIds,
      'isOpen': isOpen,
    };
  }

  factory OpportunityEntity.fromJson(Map<String, dynamic> json) {
    return OpportunityEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      creatorAvatarUrl: json['creatorAvatarUrl'] as String?,
      type: OpportunityType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => OpportunityType.procuroMusico,
      ),
      instrumentNeeded: json['instrumentNeeded'] as String? ?? 'Qualquer',
      city: json['city'] as String,
      state: json['state'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      genre: json['genre'] as String,
      cacheAmount: (json['cacheAmount'] as num?)?.toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      interestedUserIds: (json['interestedUserIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }
}
