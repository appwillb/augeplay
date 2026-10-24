import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/date_formatter.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/feed/domain/models/post_entity.dart';
import 'package:playauge/features/feed/presentation/state/feed_provider.dart';
import 'package:playauge/shared/widgets/custom_card.dart';
import 'package:playauge/shared/widgets/user_avatar.dart';

class FeedScreen extends StatefulWidget {
  final FeedProvider feedProvider;
  final UserEntity currentUser;
  final void Function(String authorId) onOpenProfile;

  const FeedScreen({
    super.key,
    required this.feedProvider,
    required this.currentUser,
    required this.onOpenProfile,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _postTextController = TextEditingController();

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  void _createQuickPost() {
    if (_postTextController.text.trim().isEmpty) return;

    final newPost = PostEntity(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorId: widget.currentUser.id,
      authorName: widget.currentUser.displayName,
      authorRole: widget.currentUser.roles.first.shortLabel,
      authorAvatarUrl: widget.currentUser.avatarUrl,
      authorLocation: widget.currentUser.locationFormatted,
      content: _postTextController.text.trim(),
      type: PostType.texto,
      createdAt: DateTime.now(),
    );

    widget.feedProvider.createPost(newPost);
    _postTextController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mural Musical & Feed'),
      ),
      body: Column(
        children: [
          // Caixa rápida de publicação
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.surfaceBorder)),
            ),
            child: Row(
              children: [
                UserAvatar(name: widget.currentUser.displayName, radius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _postTextController,
                    decoration: InputDecoration(
                      hintText: 'Compartilhe uma novidade, show ou projeto musical...',
                      hintStyle: AppTextStyles.bodySmall,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: _createQuickPost,
                ),
              ],
            ),
          ),

          // Lista de Posts do Feed
          Expanded(
            child: AnimatedBuilder(
              animation: widget.feedProvider,
              builder: (context, _) {
                final posts = widget.feedProvider.posts;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cabeçalho do Post
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => widget.onOpenProfile(post.authorId),
                                  child: UserAvatar(name: post.authorName, radius: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => widget.onOpenProfile(post.authorId),
                                        child: Text(post.authorName, style: AppTextStyles.titleSmall),
                                      ),
                                      Text(
                                        '${post.authorRole} • ${post.authorLocation} • ${DateFormatter.formatRelative(post.createdAt)}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz, color: AppColors.textMuted),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Conteúdo do Post
                            Text(post.content, style: AppTextStyles.bodyLarge),

                            if (post.attachedSongTitle != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceElevated,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.surfaceBorder),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.audiotrack_rounded, color: AppColors.primary),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Faixa Anexa: ${post.attachedSongTitle}',
                                        style: AppTextStyles.titleSmall,
                                      ),
                                    ),
                                    const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 28),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 14),
                            const Divider(height: 1),
                            const SizedBox(height: 8),

                            // Barra de Ações (Curtir, Comentar, Compartilhar)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton.icon(
                                  icon: Icon(
                                    post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                                    color: post.isLikedByMe ? AppColors.error : AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  label: Text(
                                    '${post.likesCount}',
                                    style: TextStyle(
                                      color: post.isLikedByMe ? AppColors.error : AppColors.textSecondary,
                                    ),
                                  ),
                                  onPressed: () => widget.feedProvider.toggleLike(post.id),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary, size: 18),
                                  label: Text('${post.commentsCount}', style: const TextStyle(color: AppColors.textSecondary)),
                                  onPressed: () {},
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 18),
                                  label: Text('${post.sharesCount}', style: const TextStyle(color: AppColors.textSecondary)),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
