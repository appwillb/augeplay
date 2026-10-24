import 'package:flutter/foundation.dart';
import 'package:playauge/features/videos/data/repositories/video_repository.dart';
import 'package:playauge/features/videos/domain/models/musician_video_entity.dart';

class VideoProvider extends ChangeNotifier {
  final VideoRepository _repository;

  VideoProvider(this._repository);

  List<MusicianVideoEntity> _videos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MusicianVideoEntity> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadVideosForMusician(String musicianId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _videos = await _repository.getVideosByMusician(musicianId);
    } catch (e) {
      _errorMessage = 'Erro ao carregar vídeos do músico: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadVideo(MusicianVideoEntity video) async {
    try {
      final saved = await _repository.uploadVideo(video);
      _videos.insert(0, saved);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao enviar vídeo: $e';
      notifyListeners();
    }
  }

  Future<void> likeVideo(String videoId) async {
    await _repository.toggleLike(videoId);
    final idx = _videos.indexWhere((v) => v.id == videoId);
    if (idx != -1) {
      final current = _videos[idx];
      _videos[idx] = current.copyWith(likesCount: current.likesCount + 1);
      notifyListeners();
    }
  }
}
