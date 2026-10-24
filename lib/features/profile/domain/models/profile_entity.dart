import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'availability_entity.dart';

/// Perfil Profissional Detalhado do Músico / Artista / Produtor / Compositor
class ProfileEntity {
  final UserEntity user;
  final List<String> instruments;
  final List<String> genres;
  final int yearsOfExperience;
  final AvailabilityEntity availability;
  final List<String> photoUrls;
  final List<String> videoUrls;
  final List<String> songIds;
  final List<String> bandMemberNames; // Se for banda: integrantes e funções
  final String? technicalRider; // Especificações técnicas

  const ProfileEntity({
    required this.user,
    this.instruments = const [],
    this.genres = const [],
    this.yearsOfExperience = 1,
    this.availability = const AvailabilityEntity(),
    this.photoUrls = const [],
    this.videoUrls = const [],
    this.songIds = const [],
    this.bandMemberNames = const [],
    this.technicalRider,
  });

  String get instrumentsFormatted => instruments.join(' • ');
  String get genresFormatted => genres.join(' | ');

  ProfileEntity copyWith({
    UserEntity? user,
    List<String>? instruments,
    List<String>? genres,
    int? yearsOfExperience,
    AvailabilityEntity? availability,
    List<String>? photoUrls,
    List<String>? videoUrls,
    List<String>? songIds,
    List<String>? bandMemberNames,
    String? technicalRider,
  }) {
    return ProfileEntity(
      user: user ?? this.user,
      instruments: instruments ?? this.instruments,
      genres: genres ?? this.genres,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      availability: availability ?? this.availability,
      photoUrls: photoUrls ?? this.photoUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      songIds: songIds ?? this.songIds,
      bandMemberNames: bandMemberNames ?? this.bandMemberNames,
      technicalRider: technicalRider ?? this.technicalRider,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'instruments': instruments,
      'genres': genres,
      'yearsOfExperience': yearsOfExperience,
      'availability': availability.toJson(),
      'photoUrls': photoUrls,
      'videoUrls': videoUrls,
      'songIds': songIds,
      'bandMemberNames': bandMemberNames,
      'technicalRider': technicalRider,
    };
  }

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      instruments: (json['instruments'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 1,
      availability: json['availability'] != null
          ? AvailabilityEntity.fromJson(json['availability'] as Map<String, dynamic>)
          : const AvailabilityEntity(),
      photoUrls: (json['photoUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      videoUrls: (json['videoUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      songIds: (json['songIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      bandMemberNames: (json['bandMemberNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      technicalRider: json['technicalRider'] as String?,
    );
  }
}
