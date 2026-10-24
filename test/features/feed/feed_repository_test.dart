import 'package:test/test.dart';
import 'package:playauge/features/feed/data/repositories/feed_repository.dart';
import 'package:playauge/features/feed/domain/models/post_entity.dart';

void main() {
  late FeedRepository repository;

  setUp(() {
    repository = FeedRepositoryImpl();
  });

  group('FeedRepository Tests', () {
    test('fetches social feed posts', () async {
      final posts = await repository.getFeedPosts();
      expect(posts.isNotEmpty, isTrue);
    });

    test('creates new feed post', () async {
      final post = PostEntity(
        id: 'post_new',
        authorId: 'u1',
        authorName: 'João Silva',
        authorRole: 'Cantor',
        authorLocation: 'Goiânia - GO',
        content: 'Novo show confirmado para o próximo mês!',
        createdAt: DateTime.now(),
      );

      final created = await repository.createPost(post);
      expect(created.id, equals('post_new'));

      final all = await repository.getFeedPosts();
      expect(all.first.content, contains('Novo show confirmado'));
    });

    test('toggles like and updates like count', () async {
      final all = await repository.getFeedPosts();
      final targetId = all.first.id;
      final initialLikes = all.first.likesCount;

      final liked = await repository.toggleLike(targetId);
      expect(liked.isLikedByMe, isTrue);
      expect(liked.likesCount, equals(initialLikes + 1));

      final unliked = await repository.toggleLike(targetId);
      expect(unliked.isLikedByMe, isFalse);
      expect(unliked.likesCount, equals(initialLikes));
    });
  });
}
