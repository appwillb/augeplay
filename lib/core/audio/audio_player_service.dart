import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:playauge/features/music/domain/models/song_entity.dart';

/// Status de reprodução do player
enum PlayerStatus {
  stopped,
  playing,
  paused,
  loading,
}

/// Serviço de Áudio Global Persistente para PlayAuge
/// Gerencia a reprodução contínua em segundo plano enquanto o usuário navega pelo app
class AudioPlayerService extends ChangeNotifier {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  SongEntity? _currentSong;
  PlayerStatus _status = PlayerStatus.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  List<SongEntity> _playlist = [];
  int _currentIndex = -1;
  Timer? _playbackTimer;

  // Getters
  SongEntity? get currentSong => _currentSong;
  PlayerStatus get status => _status;
  bool get isPlaying => _status == PlayerStatus.playing;
  bool get isPaused => _status == PlayerStatus.paused;
  bool get hasTrack => _currentSong != null;
  Duration get position => _position;
  Duration get duration => _duration;
  List<SongEntity> get playlist => List.unmodifiable(_playlist);

  double get progressPercentage {
    if (_duration.inMilliseconds == 0) return 0.0;
    return (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  /// Toca uma música específica
  void playSong(SongEntity song, {List<SongEntity>? queue}) {
    if (queue != null) {
      _playlist = List.from(queue);
      _currentIndex = _playlist.indexWhere((s) => s.id == song.id);
    } else if (!_playlist.any((s) => s.id == song.id)) {
      _playlist.add(song);
      _currentIndex = _playlist.length - 1;
    } else {
      _currentIndex = _playlist.indexWhere((s) => s.id == song.id);
    }

    _currentSong = song;
    _duration = song.duration;
    _position = Duration.zero;
    _status = PlayerStatus.playing;

    _startSimulationTimer();
    notifyListeners();
  }

  /// Alterna entre play e pause
  void togglePlayPause() {
    if (_currentSong == null) return;

    if (_status == PlayerStatus.playing) {
      pause();
    } else {
      resume();
    }
  }

  void pause() {
    _status = PlayerStatus.paused;
    _playbackTimer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_currentSong == null) return;
    _status = PlayerStatus.playing;
    _startSimulationTimer();
    notifyListeners();
  }

  void stop() {
    _status = PlayerStatus.stopped;
    _position = Duration.zero;
    _playbackTimer?.cancel();
    notifyListeners();
  }

  /// Próxima faixa da fila
  void next() {
    if (_playlist.isEmpty || _currentIndex + 1 >= _playlist.length) return;
    _currentIndex++;
    playSong(_playlist[_currentIndex]);
  }

  /// Faixa anterior da fila
  void previous() {
    if (_playlist.isEmpty || _currentIndex - 1 < 0) return;
    _currentIndex--;
    playSong(_playlist[_currentIndex]);
  }

  /// Avançar / retroceder para uma posição específica
  void seek(Duration newPosition) {
    _position = newPosition;
    if (_position > _duration) _position = _duration;
    if (_position < Duration.zero) _position = Duration.zero;
    notifyListeners();
  }

  void _startSimulationTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status != PlayerStatus.playing) {
        timer.cancel();
        return;
      }

      if (_position.inSeconds < _duration.inSeconds) {
        _position += const Duration(seconds: 1);
        notifyListeners();
      } else {
        // Faixa terminou
        if (_currentIndex + 1 < _playlist.length) {
          next();
        } else {
          stop();
        }
      }
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
