import 'package:flutter/foundation.dart';
import 'package:playauge/features/feed/data/repositories/feed_repository.dart';
import 'package:playauge/features/feed/domain/models/post_entity.dart';

class FeedProvider extends ChangeNotifier {
  final FeedRepository _repository;

  List<PostEntity> _posts = [];
  bool _isLoading = false;

  FeedProvider(this._repository) {
    loadFeed();
  }

  List<PostEntity> get posts => List.unmodifiable(_posts);
  bool get isLoading => _isLoading;

  Future<void> loadFeed() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _repository.getFeedPosts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(PostEntity post) async {
    await _repository.createPost(post);
    _posts.insert(0, post);
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final updated = await _repository.toggleLike(postId);
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = updated;
      notifyListeners();
    }
  }
}
