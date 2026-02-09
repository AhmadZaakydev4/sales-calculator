import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static bool _initialized = false;

  /// Initialize Indonesian locale for date formatting
  static Future<void> initialize() async {
    if (!_initialized) {
      await initializeDateFormatting('id_ID', null);
      _initialized = true;
    }
  }

  /// Format date in Indonesian locale (e.g., "9 Februari 2026")
  static String formatDate(DateTime date) {
    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format date with day name (e.g., "Senin, 9 Februari 2026")
  static String formatDateWithDay(DateTime date) {
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format time (e.g., "13:45")
  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }

  /// Format date and time (e.g., "9 Februari 2026, 13:45")
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');
    return formatter.format(date);
  }

  /// Format month and year (e.g., "Februari 2026")
  static String formatMonthYear(DateTime date) {
    final formatter = DateFormat('MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format short date (e.g., "09/02/2026")
  static String formatShortDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'id_ID');
    return formatter.format(date);
  }
}
