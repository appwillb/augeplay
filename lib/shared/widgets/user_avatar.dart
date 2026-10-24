import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';

/// Avatar de Usuário com suporte a foto de perfil, iniciais e badge de verificado
class UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;
  final bool isVerified;
  final bool showBorder;

  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24,
    this.isVerified = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join()
        : '?';

    Widget avatarContent = imageUrl != null && imageUrl!.isNotEmpty
        ? ClipOval(
            child: Image.network(
              imageUrl!,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildFallback(initials),
            ),
          )
        : _buildFallback(initials);

    if (showBorder) {
      avatarContent = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: avatarContent,
      );
    }

    if (!isVerified) return avatarContent;

    return Stack(
      children: [
        avatarContent,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallback(String initials) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceElevated,
      child: Text(
        initials.toUpperCase(),
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.primary,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
