/// Formatador de Datas e Horas para PlayAuge (Zero dependências externas)
class DateFormatter {
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  static String formatShortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  /// Formatação amigável (Ex: "Hoje às 19:00", "Ontem", "20/10/2026")
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0 && dateTime.day == now.day) {
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m atrás';
      }
      return 'Hoje às ${formatTime(dateTime)}';
    } else if (difference.inDays <= 1 && dateTime.day == now.subtract(const Duration(days: 1)).day) {
      return 'Ontem às ${formatTime(dateTime)}';
    } else {
      return formatDate(dateTime);
    }
  }
}
