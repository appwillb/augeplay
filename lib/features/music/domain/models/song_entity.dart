/// Entidade de Música Lançada / Portfólio
class SongEntity {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String? composerName;
  final String genre;
  final String audioUrl;
  final Duration duration;
  final String? musicalKey; // Tom (ex: "G maior", "Am")
  final int? bpm;
  final String? lyrics;
  final String? coverUrl;
  final DateTime releaseDate;
  final List<String> tags;
  final int playCount;
  final int likesCount;
  final bool isPublic;

  const SongEntity({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    this.composerName,
    required this.genre,
    required this.audioUrl,
    this.duration = const Duration(minutes: 3, seconds: 30),
    this.musicalKey,
    this.bpm,
    this.lyrics,
    this.coverUrl,
    required this.releaseDate,
    this.tags = const [],
    this.playCount = 0,
    this.likesCount = 0,
    this.isPublic = true,
  });

  String get durationFormatted {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  SongEntity copyWith({
    String? id,
    String? title,
    String? artistId,
    String? artistName,
    String? composerName,
    String? genre,
    String? audioUrl,
    Duration? duration,
    String? musicalKey,
    int? bpm,
    String? lyrics,
    String? coverUrl,
    DateTime? releaseDate,
    List<String>? tags,
    int? playCount,
    int? likesCount,
    bool? isPublic,
  }) {
    return SongEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      composerName: composerName ?? this.composerName,
      genre: genre ?? this.genre,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      musicalKey: musicalKey ?? this.musicalKey,
      bpm: bpm ?? this.bpm,
      lyrics: lyrics ?? this.lyrics,
      coverUrl: coverUrl ?? this.coverUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      tags: tags ?? this.tags,
      playCount: playCount ?? this.playCount,
      likesCount: likesCount ?? this.likesCount,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistId': artistId,
      'artistName': artistName,
      'composerName': composerName,
      'genre': genre,
      'audioUrl': audioUrl,
      'durationMs': duration.inMilliseconds,
      'musicalKey': musicalKey,
      'bpm': bpm,
      'lyrics': lyrics,
      'coverUrl': coverUrl,
      'releaseDate': releaseDate.toIso8601String(),
      'tags': tags,
      'playCount': playCount,
      'likesCount': likesCount,
      'isPublic': isPublic,
    };
  }

  factory SongEntity.fromJson(Map<String, dynamic> json) {
    return SongEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      artistId: json['artistId'] as String,
      artistName: json['artistName'] as String,
      composerName: json['composerName'] as String?,
      genre: json['genre'] as String,
      audioUrl: json['audioUrl'] as String,
      duration: Duration(milliseconds: json['durationMs'] as int? ?? 210000),
      musicalKey: json['musicalKey'] as String?,
      bpm: json['bpm'] as int?,
      lyrics: json['lyrics'] as String?,
      coverUrl: json['coverUrl'] as String?,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      playCount: json['playCount'] as int? ?? 0,
      likesCount: json['likesCount'] as int? ?? 0,
      isPublic: json['isPublic'] as bool? ?? true,
    );
  }
}
