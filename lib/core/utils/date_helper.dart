class DateHelper {
  static const List<String> _daysIndonesia = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _monthsIndonesia = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Converts ISO date string (e.g. "2026-11-25") or DateTime to readable format
  static String formatFullDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final dayName = _daysIndonesia[dt.weekday - 1];
      final monthName = _monthsIndonesia[dt.month - 1];
      return '$dayName, ${dt.day} $monthName ${dt.year}';
    } catch (_) {
      return isoString;
    }
  }

  /// Returns friendly day label: "Hari ini", "Besok", or "Kamis"
  static String formatForecastDay(String? isoString, int index) {
    if (index == 0) return 'Hari ini';
    if (index == 1) return 'Besok';
    if (isoString == null || isoString.isEmpty) return 'Hari $index';
    try {
      final dt = DateTime.parse(isoString);
      return _daysIndonesia[dt.weekday - 1];
    } catch (_) {
      return 'Hari $index';
    }
  }

  /// Returns short date (e.g. "25 Nov")
  static String formatShortDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final monthName = _monthsIndonesia[dt.month - 1];
      return '${dt.day} $monthName';
    } catch (_) {
      return isoString;
    }
  }

  /// Returns time string (e.g. "16:45")
  static String formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (_) {
      return '';
    }
  }
}
