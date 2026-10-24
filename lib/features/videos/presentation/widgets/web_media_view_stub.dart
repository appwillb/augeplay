import 'package:flutter/material.dart';

Widget createCameraPreview({
  required String viewId,
  required bool isFrontCamera,
  required bool isVideoOff,
}) {
  return Container(
    color: const Color(0xFF1E222D),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
            color: isVideoOff ? Colors.redAccent : const Color(0xFF10B981),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            isVideoOff ? 'Câmera Desligada' : 'Você (Ao Vivo)',
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

Widget createVideoPlayerView({
  required String viewId,
  required String videoUrl,
  required bool isPlaying,
  required bool isMuted,
}) {
  return Container(
    color: Colors.black,
    child: const Center(
      child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 48),
    ),
  );
}

void disposeWebMedia() {}
