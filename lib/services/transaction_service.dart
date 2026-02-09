import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionService {
  static const String _boxName = 'transactions';

  /// Get the Hive box for transactions
  Box<Transaction> _getBox() {
    return Hive.box<Transaction>(_boxName);
  }

  /// Save a transaction to the database
  Future<void> saveTransaction(Transaction transaction) async {
    try {
      final box = _getBox();
      await box.add(transaction);
    } catch (e) {
      throw Exception('Gagal menyimpan transaksi: $e');
    }
  }

  /// Get all transactions from the database
  Future<List<Transaction>> getAllTransactions() async {
    try {
      final box = _getBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Gagal memuat data transaksi: $e');
    }
  }

  /// Get transactions for a specific day
  Future<List<Transaction>> getTransactionsByDay(DateTime day) async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions.where((transaction) {
        return _isSameDay(transaction.transactionDate, day);
      }).toList();
    } catch (e) {
      throw Exception('Gagal memuat data transaksi: $e');
    }
  }

  /// Get transactions for a specific month
  Future<List<Transaction>> getTransactionsByMonth(int year, int month) async {
    try {
      final allTransactions = await getAllTransactions();
      return allTransactions.where((transaction) {
        return transaction.transactionDate.year == year &&
            transaction.transactionDate.month == month;
      }).toList();
    } catch (e) {
      throw Exception('Gagal memuat data transaksi: $e');
    }
  }

  /// Calculate total sales from a list of transactions
  double calculateTotal(List<Transaction> transactions) {
    return transactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.totalPrice,
    );
  }

  /// Helper method to check if two dates are on the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
