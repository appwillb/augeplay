import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

html.MediaStream? _localCameraStream;
html.VideoElement? _cameraVideoElement;
final Map<String, html.VideoElement> _videoElements = {};

Widget createCameraPreview({
  required String viewId,
  required bool isFrontCamera,
  required bool isVideoOff,
}) {
  final uniqueId = 'camera_pip_$viewId';

  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(uniqueId, (int id) {
    _cameraVideoElement = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..setAttribute('playsinline', 'true')
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.transform = isFrontCamera ? 'scaleX(-1)' : 'none';

    _startCamera(isFrontCamera);
    return _cameraVideoElement!;
  });

  if (_cameraVideoElement != null) {
    _cameraVideoElement!.style.transform = isFrontCamera ? 'scaleX(-1)' : 'none';
    if (_localCameraStream != null) {
      for (final track in _localCameraStream!.getVideoTracks()) {
        track.enabled = !isVideoOff;
      }
    }
  }

  return HtmlElementView(viewType: uniqueId);
}

void _startCamera(bool isFrontCamera) {
  html.window.navigator.mediaDevices?.getUserMedia({
    'video': {
      'facingMode': isFrontCamera ? 'user' : 'environment',
      'width': {'ideal': 640},
      'height': {'ideal': 480},
    },
    'audio': false,
  }).then((stream) {
    _localCameraStream = stream;
    if (_cameraVideoElement != null) {
      _cameraVideoElement!.srcObject = stream;
      _cameraVideoElement!.play();
    }
  }).catchError((err) {
    // Permissão negada ou sem câmera no dispositivo
  });
}

Widget createVideoPlayerView({
  required String viewId,
  required String videoUrl,
  required bool isPlaying,
  required bool isMuted,
}) {
  final uniqueId = 'video_player_$viewId';

  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(uniqueId, (int id) {
    final video = html.VideoElement()
      ..src = videoUrl
      ..autoplay = true
      ..loop = true
      ..muted = isMuted
      ..setAttribute('playsinline', 'true')
      ..setAttribute('controls', 'true')
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover';

    _videoElements[viewId] = video;
    video.play();
    return video;
  });

  final el = _videoElements[viewId];
  if (el != null) {
    el.muted = isMuted;
    if (isPlaying && el.paused) {
      el.play();
    } else if (!isPlaying && !el.paused) {
      el.pause();
    }
  }

  return HtmlElementView(viewType: uniqueId);
}

void disposeWebMedia() {
  if (_localCameraStream != null) {
    for (final track in _localCameraStream!.getTracks()) {
      track.stop();
    }
    _localCameraStream = null;
  }
  _cameraVideoElement = null;
  for (final el in _videoElements.values) {
    el.pause();
    el.src = '';
  }
  _videoElements.clear();
}
