/// Item do Repertório de Ensaio / Show
class RepertoireItem {
  final String id;
  final String songTitle;
  final String? artistOrOriginal;
  final String? musicalKey; // Tom (ex: C, G, Am)
  final int? bpm;
  final String? audioDemoUrl;
  final String? lyrics;
  final String? sheetOrTabUrl; // Cifra / Partitura
  final String? notes; // Ex: "Tocar solo no refrão 2"

  const RepertoireItem({
    required this.id,
    required this.songTitle,
    this.artistOrOriginal,
    this.musicalKey,
    this.bpm,
    this.audioDemoUrl,
    this.lyrics,
    this.sheetOrTabUrl,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'songTitle': songTitle,
      'artistOrOriginal': artistOrOriginal,
      'musicalKey': musicalKey,
      'bpm': bpm,
      'audioDemoUrl': audioDemoUrl,
      'lyrics': lyrics,
      'sheetOrTabUrl': sheetOrTabUrl,
      'notes': notes,
    };
  }

  factory RepertoireItem.fromJson(Map<String, dynamic> json) {
    return RepertoireItem(
      id: json['id'] as String,
      songTitle: json['songTitle'] as String,
      artistOrOriginal: json['artistOrOriginal'] as String?,
      musicalKey: json['musicalKey'] as String?,
      bpm: json['bpm'] as int?,
      audioDemoUrl: json['audioDemoUrl'] as String?,
      lyrics: json['lyrics'] as String?,
      sheetOrTabUrl: json['sheetOrTabUrl'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

/// Entidade de Ensaio
class RehearsalEntity {
  final String id;
  final String title;
  final String bandOrArtistName;
  final DateTime date;
  final String time;
  final String studioName;
  final String locationAddress;
  final List<String> participantNames;
  final List<String> confirmedParticipantNames;
  final List<RepertoireItem> repertoire;
  final String? notes;
  final bool isCompleted;

  const RehearsalEntity({
    required this.id,
    required this.title,
    required this.bandOrArtistName,
    required this.date,
    required this.time,
    required this.studioName,
    required this.locationAddress,
    this.participantNames = const [],
    this.confirmedParticipantNames = const [],
    this.repertoire = const [],
    this.notes,
    this.isCompleted = false,
  });

  RehearsalEntity copyWith({
    String? id,
    String? title,
    String? bandOrArtistName,
    DateTime? date,
    String? time,
    String? studioName,
    String? locationAddress,
    List<String>? participantNames,
    List<String>? confirmedParticipantNames,
    List<RepertoireItem>? repertoire,
    String? notes,
    bool? isCompleted,
  }) {
    return RehearsalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      bandOrArtistName: bandOrArtistName ?? this.bandOrArtistName,
      date: date ?? this.date,
      time: time ?? this.time,
      studioName: studioName ?? this.studioName,
      locationAddress: locationAddress ?? this.locationAddress,
      participantNames: participantNames ?? this.participantNames,
      confirmedParticipantNames: confirmedParticipantNames ?? this.confirmedParticipantNames,
      repertoire: repertoire ?? this.repertoire,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'bandOrArtistName': bandOrArtistName,
      'date': date.toIso8601String(),
      'time': time,
      'studioName': studioName,
      'locationAddress': locationAddress,
      'participantNames': participantNames,
      'confirmedParticipantNames': confirmedParticipantNames,
      'repertoire': repertoire.map((r) => r.toJson()).toList(),
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory RehearsalEntity.fromJson(Map<String, dynamic> json) {
    return RehearsalEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      bandOrArtistName: json['bandOrArtistName'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      studioName: json['studioName'] as String,
      locationAddress: json['locationAddress'] as String,
      participantNames: (json['participantNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      confirmedParticipantNames: (json['confirmedParticipantNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      repertoire: (json['repertoire'] as List<dynamic>?)
              ?.map((e) => RepertoireItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
