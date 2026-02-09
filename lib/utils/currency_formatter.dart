import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Format amount as Indonesian Rupiah (e.g., "Rp 1.000.000")
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format amount with decimal places (e.g., "Rp 1.000.000,50")
  static String formatWithDecimals(double amount, {int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format amount without currency symbol (e.g., "1.000.000")
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }

  /// Format amount compactly (e.g., "1,2 Jt" for 1.200.000)
  static String formatCompact(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)} M';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} Jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(1)} Rb';
    } else {
      return format(amount);
    }
  }
}
