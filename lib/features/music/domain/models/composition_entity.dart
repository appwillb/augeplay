/// Visibilidade da Composição
enum CompositionVisibility {
  privada,
  seguidores,
  publica;

  String get label {
    switch (this) {
      case CompositionVisibility.privada:
        return 'Privada';
      case CompositionVisibility.seguidores:
        return 'Apenas Seguidores';
      case CompositionVisibility.publica:
        return 'Pública (Todos)';
    }
  }
}

/// Entidade de Composição (Foco em Compositores procurando Artistas e Parcerias)
class CompositionEntity {
  final String id;
  final String title;
  final String composerId;
  final String composerName;
  final List<String> coAuthors;
  final String? demoAudioUrl;
  final String lyrics;
  final String genre;
  final String? musicalKey;
  final int? bpm;
  final String? description;
  final DateTime createdAt;
  final CompositionVisibility visibility;
  final bool lookingForArtist; // PROCURA-SE ARTISTA
  final bool lookingForProducer; // PROCURA-SE PRODUTOR
  final bool lookingForPartnership; // PROCURA-SE PARCERIA
  final int interestedCount;

  const CompositionEntity({
    required this.id,
    required this.title,
    required this.composerId,
    required this.composerName,
    this.coAuthors = const [],
    this.demoAudioUrl,
    required this.lyrics,
    required this.genre,
    this.musicalKey,
    this.bpm,
    this.description,
    required this.createdAt,
    this.visibility = CompositionVisibility.publica,
    this.lookingForArtist = true,
    this.lookingForProducer = false,
    this.lookingForPartnership = false,
    this.interestedCount = 0,
  });

  CompositionEntity copyWith({
    String? id,
    String? title,
    String? composerId,
    String? composerName,
    List<String>? coAuthors,
    String? demoAudioUrl,
    String? lyrics,
    String? genre,
    String? musicalKey,
    int? bpm,
    String? description,
    DateTime? createdAt,
    CompositionVisibility? visibility,
    bool? lookingForArtist,
    bool? lookingForProducer,
    bool? lookingForPartnership,
    int? interestedCount,
  }) {
    return CompositionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      composerId: composerId ?? this.composerId,
      composerName: composerName ?? this.composerName,
      coAuthors: coAuthors ?? this.coAuthors,
      demoAudioUrl: demoAudioUrl ?? this.demoAudioUrl,
      lyrics: lyrics ?? this.lyrics,
      genre: genre ?? this.genre,
      musicalKey: musicalKey ?? this.musicalKey,
      bpm: bpm ?? this.bpm,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      visibility: visibility ?? this.visibility,
      lookingForArtist: lookingForArtist ?? this.lookingForArtist,
      lookingForProducer: lookingForProducer ?? this.lookingForProducer,
      lookingForPartnership: lookingForPartnership ?? this.lookingForPartnership,
      interestedCount: interestedCount ?? this.interestedCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'composerId': composerId,
      'composerName': composerName,
      'coAuthors': coAuthors,
      'demoAudioUrl': demoAudioUrl,
      'lyrics': lyrics,
      'genre': genre,
      'musicalKey': musicalKey,
      'bpm': bpm,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'visibility': visibility.name,
      'lookingForArtist': lookingForArtist,
      'lookingForProducer': lookingForProducer,
      'lookingForPartnership': lookingForPartnership,
      'interestedCount': interestedCount,
    };
  }

  factory CompositionEntity.fromJson(Map<String, dynamic> json) {
    return CompositionEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      composerId: json['composerId'] as String,
      composerName: json['composerName'] as String,
      coAuthors: (json['coAuthors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      demoAudioUrl: json['demoAudioUrl'] as String?,
      lyrics: json['lyrics'] as String,
      genre: json['genre'] as String,
      musicalKey: json['musicalKey'] as String?,
      bpm: json['bpm'] as int?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      visibility: CompositionVisibility.values.firstWhere(
        (v) => v.name == json['visibility'],
        orElse: () => CompositionVisibility.publica,
      ),
      lookingForArtist: json['lookingForArtist'] as bool? ?? true,
      lookingForProducer: json['lookingForProducer'] as bool? ?? false,
      lookingForPartnership: json['lookingForPartnership'] as bool? ?? false,
      interestedCount: json['interestedCount'] as int? ?? 0,
    );
  }
}
