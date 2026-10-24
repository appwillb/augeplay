import 'dart:async';
import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/currency_formatter.dart';
import 'package:playauge/features/auth/domain/models/user_entity.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/videos/presentation/widgets/web_media_view.dart';
import 'package:playauge/features/videos/data/call_signaling_service.dart';

/// Tela de Chamada de Vídeo para Audição Online e Negociação Direta de Cachê
class VideoCallScreen extends StatefulWidget {
  final UserEntity callerUser;
  final ProfileEntity targetProfile;
  final double? proposedCache;
  final VoidCallback? onContractAgreed;

  const VideoCallScreen({
    super.key,
    required this.callerUser,
    required this.targetProfile,
    this.proposedCache,
    this.onContractAgreed,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isFrontCamera = true;
  bool _showPerformanceVideo = true;
  int _callDurationSeconds = 0;
  Timer? _callTimer;

  late double _currentProposedCache;

  @override
  void initState() {
    super.initState();
    _currentProposedCache = widget.proposedCache ?? widget.targetProfile.availability.baseRate ?? 800.0;
    _startTimer();
    CallSignalingService().addListener(_onSignalingStateChanged);
  }

  void _onSignalingStateChanged() {
    // Escuta eventos de encerramento remoto
  }

  void _endCall() {
    CallSignalingService().endCall(widget.targetProfile.user.id);
    disposeWebMedia();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _startTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDurationSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    CallSignalingService().removeListener(_onSignalingStateChanged);
    _callTimer?.cancel();
    disposeWebMedia();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showCloseDealModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.handshake_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Fechar Acordo na Chamada'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmar cachê acordado com ${widget.targetProfile.user.displayName}:',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              CurrencyFormatter.formatBRL(_currentProposedCache),
              style: AppTextStyles.displayLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            const Text(
              'O pré-contrato será gerado e enviado para o chat de ambos com status confirmado.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuar Audição'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.success,
                  content: Text('Acordo firmado no valor de ${CurrencyFormatter.formatBRL(_currentProposedCache)}!'),
                ),
              );
              if (widget.onContractAgreed != null) {
                widget.onContractAgreed!();
              }
              disposeWebMedia();
              Navigator.pop(context);
            },
            child: const Text('Confirmar Cachê'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetUser = widget.targetProfile.user;
    final auditionVideoUrl = widget.targetProfile.videoUrls.isNotEmpty
        ? widget.targetProfile.videoUrls.first
        : 'https://assets.mixkit.co/videos/preview/mixkit-guitarist-playing-an-acoustic-guitar-42526-large.mp4';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Câmera Remota (Músico Tocando ao Vivo na Audição)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF14171F),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_showPerformanceVideo)
                    createVideoPlayerView(
                      viewId: 'remote_audition_${targetUser.id}',
                      videoUrl: auditionVideoUrl,
                      isPlaying: true,
                      isMuted: _isMuted,
                    )
                  else if (targetUser.avatarUrl != null && targetUser.avatarUrl!.isNotEmpty)
                    Image.network(
                      targetUser.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.person, size: 100, color: Colors.white24),
                      ),
                    )
                  else
                    const Center(
                      child: Icon(Icons.person, size: 100, color: Colors.white24),
                    ),

                  // Overlay superior
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.8)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('AUDIÇÃO AO VIVO', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text(_formatDuration(_callDurationSeconds), style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Câmera Local (Picture-in-Picture com WEBCAM / CÂMERA REAL DO USUÁRIO)
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 120,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!_isVideoOff)
                      createCameraPreview(
                        viewId: 'caller_pip',
                        isFrontCamera: _isFrontCamera,
                        isVideoOff: _isVideoOff,
                      )
                    else
                      Container(
                        color: const Color(0xFF1E222D),
                        child: const Center(
                          child: Icon(Icons.videocam_off_rounded, color: Colors.redAccent, size: 32),
                        ),
                      ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _isVideoOff ? 'Desligada' : 'Você (Ao Vivo)',
                          style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Painel de Negociação de Cachê Flutuante
          Positioned(
            top: 100,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    targetUser.displayName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    widget.targetProfile.instrumentsFormatted.isNotEmpty
                        ? widget.targetProfile.instrumentsFormatted
                        : 'Músico Profissional',
                    style: const TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('Cachê acordado: ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      Text(
                        CurrencyFormatter.formatBRL(_currentProposedCache),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Barra Inferior de Controles da Chamada
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Botão de ação rápida: "Fechar Acordo"
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    icon: const Icon(Icons.handshake_rounded, size: 20),
                    label: const Text('Acertar Cachê & Fechar Gig', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _showCloseDealModal,
                  ),
                ),

                // Controles circulares (Mute, Vídeo, Câmera, Desligar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      isActive: _isMuted,
                      onPressed: () => setState(() => _isMuted = !_isMuted),
                      tooltip: _isMuted ? 'Desmutar' : 'Mutar',
                    ),
                    // Video On/Off
                    _buildControlButton(
                      icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                      isActive: _isVideoOff,
                      onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                      tooltip: _isVideoOff ? 'Ligar Câmera' : 'Desligar Câmera',
                    ),
                    // Alternar Vídeo Remoto / Avatar
                    _buildControlButton(
                      icon: _showPerformanceVideo ? Icons.smart_display_rounded : Icons.person_pin_rounded,
                      isActive: _showPerformanceVideo,
                      onPressed: () => setState(() => _showPerformanceVideo = !_showPerformanceVideo),
                      tooltip: 'Alternar Vídeo do Músico',
                    ),
                    // Trocar Câmera
                    _buildControlButton(
                      icon: Icons.flip_camera_ios_rounded,
                      isActive: false,
                      onPressed: () => setState(() => _isFrontCamera = !_isFrontCamera),
                      tooltip: 'Alternar Câmera',
                    ),
                    // Desligar Chamada
                    FloatingActionButton(
                      heroTag: 'end_call_btn',
                      backgroundColor: Colors.redAccent,
                      onPressed: _endCall,
                      child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.black : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
