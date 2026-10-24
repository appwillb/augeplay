import 'package:flutter/foundation.dart';
import 'package:playauge/features/music/data/repositories/music_repository.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';

class MusicProvider extends ChangeNotifier {
  final MusicRepository _repository;

  List<SongEntity> _songs = [];
  List<CompositionEntity> _compositions = [];
  bool _isLoading = false;

  MusicProvider(this._repository) {
    loadContent();
  }

  List<SongEntity> get songs => List.unmodifiable(_songs);
  List<CompositionEntity> get compositions => List.unmodifiable(_compositions);
  bool get isLoading => _isLoading;

  Future<void> loadContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _repository.getSongs();
      _compositions = await _repository.getCompositions();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> publishSong(SongEntity song) async {
    await _repository.publishSong(song);
    await loadContent();
  }

  Future<void> publishComposition(CompositionEntity composition) async {
    await _repository.publishComposition(composition);
    await loadContent();
  }

  Future<void> toggleInterestInComposition(String compositionId, String userId) async {
    await _repository.toggleInterestInComposition(compositionId, userId);
    await loadContent();
  }
}
