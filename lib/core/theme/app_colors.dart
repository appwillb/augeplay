import 'package:flutter/material.dart';

/// Paleta de Cores do Design System PlayAuge
/// Conceito: Moderno, Elegante, Musical, Noturno (Stage / Studio vibe)
class AppColors {
  // Cores de Fundo e Superfície
  static const Color background = Color(0xFF0F1015);
  static const Color surface = Color(0xFF181A22);
  static const Color surfaceElevated = Color(0xFF222531);
  static const Color surfaceBorder = Color(0xFF2E3345);

  // Cores Primárias (Dourado / Âmbar Musical - Luz de Palco)
  static const Color primary = Color(0xFFFFB800);
  static const Color primaryLight = Color(0xFFFFCE48);
  static const Color primaryDark = Color(0xFFC78F00);

  // Cores Secundárias / Acento (Roxo / Púrpura Neon - Acústico & Criativo)
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF6D28D9);

  // Status de Disponibilidade e Indicadores
  static const Color availableGreen = Color(0xFF10B981); // 🟢 Disponível
  static const Color unavailableGray = Color(0xFF6B7280); // ⚪ Indisponível
  static const Color busyRed = Color(0xFFEF4444);        // 🔴 Ocupado
  static const Color pendingYellow = Color(0xFFF59E0B);    // 🟡 A confirmar / Negociando

  // Textos
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textInverse = Color(0xFF111827);

  // Feedback
  static const Color error = Color(0xFFF87171);
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF60A5FA);

  // Gradientes Musicais
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFFF8B00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1F222E), Color(0xFF181A22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient playerGradient = LinearGradient(
    colors: [Color(0xFF222531), Color(0xFF161820)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
