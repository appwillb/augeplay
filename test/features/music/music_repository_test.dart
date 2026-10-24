import 'package:test/test.dart';
import 'package:playauge/features/music/data/repositories/music_repository.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';

void main() {
  late MusicRepository repository;

  setUp(() {
    repository = MusicRepositoryImpl();
  });

  group('MusicRepository Tests', () {
    test('fetches released songs', () async {
      final songs = await repository.getSongs();
      expect(songs.isNotEmpty, isTrue);
      expect(songs.first.title, contains('Destino'));
    });

    test('publishes new song', () async {
      final song = SongEntity(
        id: 'new_song_test',
        title: 'Acordes da Noite',
        artistId: 'art_1',
        artistName: 'Artista Teste',
        genre: 'MPB',
        audioUrl: 'https://cdn.playauge.com/audio/acordes.mp3',
        releaseDate: DateTime.now(),
      );

      final published = await repository.publishSong(song);
      expect(published.id, equals('new_song_test'));

      final all = await repository.getSongs();
      expect(all.first.title, equals('Acordes da Noite'));
    });

    test('publishes and toggles interest in composition', () async {
      final comp = CompositionEntity(
        id: 'comp_test',
        title: 'Canção do Vento',
        composerId: 'comp_1',
        composerName: 'Compositor Teste',
        lyrics: 'Vento que sopra...',
        genre: 'Sertanejo',
        createdAt: DateTime.now(),
        lookingForArtist: true,
      );

      await repository.publishComposition(comp);
      await repository.toggleInterestInComposition('comp_test', 'user_interested');

      final list = await repository.getCompositions();
      final updated = list.firstWhere((c) => c.id == 'comp_test');
      expect(updated.interestedCount, equals(1));
    });
  });
}
