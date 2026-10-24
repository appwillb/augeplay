import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';

/// Card customizado com suporte a gradiente e borda sutil
class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderSide? border;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border?.color ?? AppColors.surfaceBorder,
          width: border?.width ?? 1,
        ),
      ),
      child: child,
    );

    if (onTap == null) return cardContent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: cardContent,
    );
  }
}
