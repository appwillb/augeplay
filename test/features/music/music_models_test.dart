import 'package:test/test.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';
import 'package:playauge/features/music/domain/models/composition_entity.dart';

void main() {
  group('Music Domain Models Tests', () {
    test('SongEntity formats duration properly', () {
      final song = SongEntity(
        id: 's1',
        title: 'Estrada do Destino',
        artistId: 'a1',
        artistName: 'João Silva',
        genre: 'Sertanejo',
        audioUrl: 'https://example.com/audio.mp3',
        duration: const Duration(minutes: 3, seconds: 45),
        releaseDate: DateTime(2026, 1, 1),
      );

      expect(song.durationFormatted, equals('03:45'));
    });

    test('SongEntity JSON serialization and deserialization', () {
      final song = SongEntity(
        id: 's1',
        title: 'Música Teste',
        artistId: 'a1',
        artistName: 'Artista Teste',
        composerName: 'Compositor Teste',
        genre: 'Pop',
        audioUrl: 'https://example.com/test.mp3',
        musicalKey: 'C Maior',
        bpm: 120,
        releaseDate: DateTime(2026, 5, 10),
      );

      final json = song.toJson();
      expect(json['title'], equals('Música Teste'));
      expect(json['bpm'], equals(120));

      final fromJson = SongEntity.fromJson(json);
      expect(fromJson.title, equals(song.title));
      expect(fromJson.bpm, equals(120));
      expect(fromJson.musicalKey, equals('C Maior'));
    });

    test('CompositionEntity looking-for flags and serialization', () {
      final comp = CompositionEntity(
        id: 'c1',
        title: 'Madrugada Fria',
        composerId: 'u1',
        composerName: 'Ana Martins',
        lyrics: 'Madrugada fria...',
        genre: 'Sertanejo',
        createdAt: DateTime(2026, 10, 1),
        lookingForArtist: true,
        lookingForProducer: true,
        interestedCount: 5,
      );

      final json = comp.toJson();
      expect(json['lookingForArtist'], isTrue);
      expect(json['lookingForProducer'], isTrue);

      final fromJson = CompositionEntity.fromJson(json);
      expect(fromJson.lookingForArtist, isTrue);
      expect(fromJson.interestedCount, equals(5));
      expect(fromJson.title, equals('Madrugada Fria'));
    });
  });
}
