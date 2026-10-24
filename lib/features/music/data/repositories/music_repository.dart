import 'package:playauge/core/constants/mock_data.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';

abstract class MusicRepository {
  Future<List<SongEntity>> getSongs();
  Future<List<SongEntity>> getSongsByArtistId(String artistId);
  Future<List<CompositionEntity>> getCompositions();
  Future<List<CompositionEntity>> getCompositionsByComposerId(String composerId);
  Future<SongEntity> publishSong(SongEntity song);
  Future<CompositionEntity> publishComposition(CompositionEntity composition);
  Future<void> toggleInterestInComposition(String compositionId, String userId);
}

class MusicRepositoryImpl implements MusicRepository {
  final List<SongEntity> _songs = List.from(MockData.songs);
  final List<CompositionEntity> _compositions = List.from(MockData.compositions);

  @override
  Future<List<SongEntity>> getSongs() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_songs);
  }

  @override
  Future<List<SongEntity>> getSongsByArtistId(String artistId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _songs.where((s) => s.artistId == artistId).toList();
  }

  @override
  Future<List<CompositionEntity>> getCompositions() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_compositions);
  }

  @override
  Future<List<CompositionEntity>> getCompositionsByComposerId(String composerId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _compositions.where((c) => c.composerId == composerId).toList();
  }

  @override
  Future<SongEntity> publishSong(SongEntity song) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _songs.insert(0, song);
    return song;
  }

  @override
  Future<CompositionEntity> publishComposition(CompositionEntity composition) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _compositions.insert(0, composition);
    return composition;
  }

  @override
  Future<void> toggleInterestInComposition(String compositionId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _compositions.indexWhere((c) => c.id == compositionId);
    if (index != -1) {
      final current = _compositions[index];
      _compositions[index] = current.copyWith(
        interestedCount: current.interestedCount + 1,
      );
    }
  }
}
