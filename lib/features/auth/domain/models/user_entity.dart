import 'user_role.dart';

/// Entidade de Usuário no PlayAuge
class UserEntity {
  final String id;
  final String name;
  final String stageName;
  final String email;
  final String city;
  final String state;
  final String country;
  final String bio;
  final List<UserRole> roles;
  final String? avatarUrl;
  final double rating;
  final int ratingsCount;
  final int followersCount;
  final int followingCount;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.stageName,
    required this.email,
    required this.city,
    required this.state,
    this.country = 'Brasil',
    required this.bio,
    required this.roles,
    this.avatarUrl,
    this.rating = 5.0,
    this.ratingsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isVerified = false,
  });

  String get displayName => stageName.isNotEmpty ? stageName : name;
  String get locationFormatted => '$city - $state';

  UserEntity copyWith({
    String? id,
    String? name,
    String? stageName,
    String? email,
    String? city,
    String? state,
    String? country,
    String? bio,
    List<UserRole>? roles,
    String? avatarUrl,
    double? rating,
    int? ratingsCount,
    int? followersCount,
    int? followingCount,
    bool? isVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      stageName: stageName ?? this.stageName,
      email: email ?? this.email,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      roles: roles ?? this.roles,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stageName': stageName,
      'email': email,
      'city': city,
      'state': state,
      'country': country,
      'bio': bio,
      'roles': roles.map((r) => r.name).toList(),
      'avatarUrl': avatarUrl,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'isVerified': isVerified,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      stageName: json['stageName'] as String? ?? '',
      email: json['email'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String? ?? 'Brasil',
      bio: json['bio'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((r) => UserRole.fromString(r.toString()))
              .toList() ??
          [UserRole.musico],
      avatarUrl: json['avatarUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      ratingsCount: json['ratingsCount'] as int? ?? 0,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}
