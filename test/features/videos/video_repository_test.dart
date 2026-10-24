import 'package:flutter_test/flutter_test.dart';
import 'package:playauge/features/videos/data/repositories/video_repository.dart';
import 'package:playauge/features/videos/domain/models/musician_video_entity.dart';

void main() {
  group('VideoRepository & MusicianVideoEntity Tests', () {
    late VideoRepository repository;

    setUp(() {
      repository = VideoRepositoryImpl();
    });

    test('MusicianVideoEntity formats duration correctly', () {
      final video = MusicianVideoEntity(
        id: 'v1',
        musicianId: 'm1',
        musicianName: 'Guitarrista',
        title: 'Solo Blues',
        description: 'Improviso em Mi menor',
        instrument: 'Guitarra',
        videoUrl: 'https://cdn.example.com/video.mp4',
        thumbnailUrl: 'https://cdn.example.com/thumb.jpg',
        duration: const Duration(minutes: 2, seconds: 5),
        createdAt: DateTime.now(),
      );

      expect(video.durationFormatted, '02:05');
    });

    test('getVideosByMusician returns videos for specific musician', () async {
      final videos = await repository.getVideosByMusician('user_lucas_guitar');
      expect(videos, isNotEmpty);
      expect(videos.first.musicianId, 'user_lucas_guitar');
    });

    test('uploadVideo inserts new video to top', () async {
      final newVideo = MusicianVideoEntity(
        id: 'new_video_test',
        musicianId: 'user_test',
        musicianName: 'Baterista Teste',
        title: 'Virada de Bateria 140 BPM',
        description: 'Ensaio técnico',
        instrument: 'Bateria',
        videoUrl: 'https://example.com/bat.mp4',
        thumbnailUrl: 'https://example.com/bat.jpg',
        duration: const Duration(minutes: 1),
        createdAt: DateTime.now(),
      );

      final uploaded = await repository.uploadVideo(newVideo);
      expect(uploaded.id, 'new_video_test');

      final trending = await repository.getTrendingVideos();
      expect(trending.first.id, 'new_video_test');
    });

    test('toggleLike increments video like count', () async {
      final initialVideos = await repository.getTrendingVideos();
      final videoId = initialVideos.first.id;
      final initialLikes = initialVideos.first.likesCount;

      await repository.toggleLike(videoId);

      final updatedVideos = await repository.getTrendingVideos();
      final updated = updatedVideos.firstWhere((v) => v.id == videoId);
      expect(updated.likesCount, initialLikes + 1);
    });
  });
}
