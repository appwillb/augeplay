import 'package:playauge/features/videos/domain/models/musician_video_entity.dart';

abstract class VideoRepository {
  Future<List<MusicianVideoEntity>> getVideosByMusician(String musicianId);
  Future<List<MusicianVideoEntity>> getTrendingVideos();
  Future<MusicianVideoEntity> uploadVideo(MusicianVideoEntity video);
  Future<void> toggleLike(String videoId);
}

class VideoRepositoryImpl implements VideoRepository {
  final List<MusicianVideoEntity> _mockVideos = [
    MusicianVideoEntity(
      id: 'vid_1',
      musicianId: 'user_lucas_guitar',
      musicianName: 'Lucas Lima (Guitarra)',
      title: 'Solo de Guitarra - Ensaio Acústico e Improviso',
      description: 'Testando overdrive novo e fraseado pentatônico com arpejos no ensaio.',
      instrument: 'Guitarra',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-guitarist-playing-an-acoustic-guitar-42526-large.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
      duration: const Duration(minutes: 1, seconds: 45),
      viewsCount: 1240,
      likesCount: 184,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MusicianVideoEntity(
      id: 'vid_2',
      musicianId: 'user_lucas_guitar',
      musicianName: 'Lucas Lima (Guitarra)',
      title: 'Passagem de Som ao Vivo - Festival Sertanejo',
      description: 'Base e solo na passagem de som da banda antes de abrir o evento.',
      instrument: 'Guitarra',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-close-up-of-hands-playing-guitar-strings-42517-large.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=600',
      duration: const Duration(minutes: 2, seconds: 12),
      viewsCount: 2310,
      likesCount: 312,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MusicianVideoEntity(
      id: 'vid_3',
      musicianId: 'user_pedro_santos',
      musicianName: 'Pedro Santos',
      title: 'Groove de Baixo & Bateria - Ensaio Funk/Groove',
      description: 'Pegada forte no baixo de 5 cordas para shows de pop e rock.',
      instrument: 'Baixo',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-bass-player-performing-on-stage-42522-large.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1520523839898-507125cd53c1?w=600',
      duration: const Duration(minutes: 1, seconds: 15),
      viewsCount: 890,
      likesCount: 97,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    MusicianVideoEntity(
      id: 'vid_4',
      musicianId: 'user_pedro_santos',
      musicianName: 'Pedro Santos',
      title: 'Solo de Baixo - Slap & Tapping',
      description: 'Demonstração técnica de precisão e afinação para gravações de estúdio.',
      instrument: 'Baixo',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-hands-of-a-guitarist-playing-chords-42521-large.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=600',
      duration: const Duration(seconds: 58),
      viewsCount: 1420,
      likesCount: 204,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    MusicianVideoEntity(
      id: 'vid_5',
      musicianId: 'user_marina_violao',
      musicianName: 'Marina Silva (Vocal e Violão)',
      title: 'Voz & Violão - Canção Autoral no Estúdio',
      description: 'Tom de Ré Maior, dedilhado suave com voz principal.',
      instrument: 'Violão',
      videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-woman-playing-guitar-and-singing-in-nature-42531-large.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=600',
      duration: const Duration(minutes: 2, seconds: 40),
      viewsCount: 3100,
      likesCount: 420,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Future<List<MusicianVideoEntity>> getVideosByMusician(String musicianId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final result = _mockVideos.where((v) => v.musicianId == musicianId).toList();
    if (result.isEmpty) {
      // Retorna amostras genéricas caso o músico não tenha vídeos específicos cadastrados
      return _mockVideos.take(2).toList();
    }
    return result;
  }

  @override
  Future<List<MusicianVideoEntity>> getTrendingVideos() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(_mockVideos);
  }

  @override
  Future<MusicianVideoEntity> uploadVideo(MusicianVideoEntity video) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockVideos.insert(0, video);
    return video;
  }

  @override
  Future<void> toggleLike(String videoId) async {
    final idx = _mockVideos.indexWhere((v) => v.id == videoId);
    if (idx != -1) {
      final current = _mockVideos[idx];
      _mockVideos[idx] = current.copyWith(likesCount: current.likesCount + 1);
    }
  }
}
