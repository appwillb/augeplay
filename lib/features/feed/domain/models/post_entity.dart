/// Tipos de Conteúdo no Feed PlayAuge
enum PostType {
  texto,
  foto,
  video,
  musica,
  composicao,
  divulgacaoShow,
  oportunidade,
  ensaio,
}

/// Entidade de Publicação no Feed
class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String? authorAvatarUrl;
  final String authorLocation;
  final String content;
  final PostType type;
  final String? mediaUrl;
  final String? attachedSongTitle;
  final String? attachedAudioUrl;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLikedByMe;
  final bool isSavedByMe;

  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    this.authorAvatarUrl,
    required this.authorLocation,
    required this.content,
    this.type = PostType.texto,
    this.mediaUrl,
    this.attachedSongTitle,
    this.attachedAudioUrl,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLikedByMe = false,
    this.isSavedByMe = false,
  });

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? authorAvatarUrl,
    String? authorLocation,
    String? content,
    PostType? type,
    String? mediaUrl,
    String? attachedSongTitle,
    String? attachedAudioUrl,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLikedByMe,
    bool? isSavedByMe,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorLocation: authorLocation ?? this.authorLocation,
      content: content ?? this.content,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      attachedSongTitle: attachedSongTitle ?? this.attachedSongTitle,
      attachedAudioUrl: attachedAudioUrl ?? this.attachedAudioUrl,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isSavedByMe: isSavedByMe ?? this.isSavedByMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatarUrl': authorAvatarUrl,
      'authorLocation': authorLocation,
      'content': content,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'attachedSongTitle': attachedSongTitle,
      'attachedAudioUrl': attachedAudioUrl,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'isLikedByMe': isLikedByMe,
      'isSavedByMe': isSavedByMe,
    };
  }

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String? ?? 'Músico',
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      authorLocation: json['authorLocation'] as String? ?? 'Brasil',
      content: json['content'] as String,
      type: PostType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => PostType.texto,
      ),
      mediaUrl: json['mediaUrl'] as String?,
      attachedSongTitle: json['attachedSongTitle'] as String?,
      attachedAudioUrl: json['attachedAudioUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      sharesCount: json['sharesCount'] as int? ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
      isSavedByMe: json['isSavedByMe'] as bool? ?? false,
    );
  }
}
