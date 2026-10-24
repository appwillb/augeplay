import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/feed/domain/models/post_entity.dart';

abstract class FeedRepository {
  Future<List<PostEntity>> getFeedPosts();
  Future<PostEntity> createPost(PostEntity post);
  Future<PostEntity> toggleLike(String postId);
}

class FeedRepositoryImpl implements FeedRepository {
  final List<PostEntity> _posts = List.from(MockData.feedPosts);

  @override
  Future<List<PostEntity>> getFeedPosts() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_posts);
  }

  @override
  Future<PostEntity> createPost(PostEntity post) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _posts.insert(0, post);
    return post;
  }

  @override
  Future<PostEntity> toggleLike(String postId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final p = _posts[index];
      final isLiked = !p.isLikedByMe;
      final count = isLiked ? p.likesCount + 1 : p.likesCount - 1;
      final updated = p.copyWith(isLikedByMe: isLiked, likesCount: count);
      _posts[index] = updated;
      return updated;
    }
    throw Exception('Post não encontrado');
  }
}
