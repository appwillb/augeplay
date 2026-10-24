import 'dart:convert';

/// Entidade que representa um vídeo gravado de solo, apresentação ou ensaio do músico
class MusicianVideoEntity {
  final String id;
  final String musicianId;
  final String musicianName;
  final String title;
  final String description;
  final String instrument;
  final String videoUrl;
  final String thumbnailUrl;
  final Duration duration;
  final int viewsCount;
  final int likesCount;
  final DateTime createdAt;

  const MusicianVideoEntity({
    required this.id,
    required this.musicianId,
    required this.musicianName,
    required this.title,
    required this.description,
    required this.instrument,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    this.viewsCount = 0,
    this.likesCount = 0,
    required this.createdAt,
  });

  String get durationFormatted {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  MusicianVideoEntity copyWith({
    String? id,
    String? musicianId,
    String? musicianName,
    String? title,
    String? description,
    String? instrument,
    String? videoUrl,
    String? thumbnailUrl,
    Duration? duration,
    int? viewsCount,
    int? likesCount,
    DateTime? createdAt,
  }) {
    return MusicianVideoEntity(
      id: id ?? this.id,
      musicianId: musicianId ?? this.musicianId,
      musicianName: musicianName ?? this.musicianName,
      title: title ?? this.title,
      description: description ?? this.description,
      instrument: instrument ?? this.instrument,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'musicianId': musicianId,
      'musicianName': musicianName,
      'title': title,
      'description': description,
      'instrument': instrument,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'durationMs': duration.inMilliseconds,
      'viewsCount': viewsCount,
      'likesCount': likesCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MusicianVideoEntity.fromMap(Map<String, dynamic> map) {
    return MusicianVideoEntity(
      id: map['id'] ?? '',
      musicianId: map['musicianId'] ?? '',
      musicianName: map['musicianName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      instrument: map['instrument'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      duration: Duration(milliseconds: map['durationMs'] ?? 0),
      viewsCount: map['viewsCount'] ?? 0,
      likesCount: map['likesCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory MusicianVideoEntity.fromJson(String source) => MusicianVideoEntity.fromMap(json.decode(source));
}
