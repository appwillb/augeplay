import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';

/// Badge visual de status de disponibilidade (🟢 Disponível / ⚪ Indisponível)
class AvailabilityBadge extends StatelessWidget {
  final bool isAvailable;
  final bool compact;

  const AvailabilityBadge({
    super.key,
    required this.isAvailable,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? AppColors.availableGreen : AppColors.unavailableGray;
    final label = isAvailable ? 'Disponível' : 'Indisponível';

    if (compact) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: isAvailable
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4, spreadRadius: 1)]
              : null,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isAvailable
                  ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 4, spreadRadius: 1)]
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.badgeText.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
