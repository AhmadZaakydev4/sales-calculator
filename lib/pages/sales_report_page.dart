import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  final _transactionService = TransactionService();
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  DateTime? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactions = await _transactionService.getAllTransactions();

      // Sort by date, most recent first
      transactions.sort(
        (a, b) => b.transactionDate.compareTo(a.transactionDate),
      );

      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data transaksi';
        _isLoading = false;
      });
    }
  }

  Future<void> _filterByDay() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDay = selectedDate;
        _selectedMonth = null;
        _selectedYear = null;
      });
      _applyDayFilter(selectedDate);
    }
  }

  Future<void> _filterByMonth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null) {
      setState(() {
        _selectedMonth = selectedDate.month;
        _selectedYear = selectedDate.year;
        _selectedDay = null;
      });
      _applyMonthFilter(selectedDate.year, selectedDate.month);
    }
  }

  void _applyDayFilter(DateTime day) async {
    try {
      final filtered = await _transactionService.getTransactionsByDay(day);
      filtered.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      setState(() {
        _filteredTransactions = filtered;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data transaksi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyMonthFilter(int year, int month) async {
    try {
      final filtered = await _transactionService.getTransactionsByMonth(
        year,
        month,
      );
      filtered.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      setState(() {
        _filteredTransactions = filtered;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data transaksi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDay = null;
      _selectedMonth = null;
      _selectedYear = null;
      _filteredTransactions = _transactions;
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  String _formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final total = _transactionService.calculateTotal(_filteredTransactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _filterByDay,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Filter Hari'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _filterByMonth,
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Filter Bulan'),
                      ),
                    ),
                  ],
                ),
                if (_selectedDay != null || _selectedMonth != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDay != null
                              ? 'Filter: ${_formatDate(_selectedDay!)}'
                              : 'Filter: ${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(_selectedYear!, _selectedMonth!))}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _clearFilter,
                        icon: const Icon(Icons.clear),
                        label: const Text('Hapus Filter'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Total Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Penjualan:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatCurrency(total),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTransactions,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : _filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedDay != null || _selectedMonth != null
                              ? 'Tidak ada transaksi untuk filter ini'
                              : 'Belum ada transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadTransactions,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _filteredTransactions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(transaction.transactionDate),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      _formatTime(transaction.transactionDate),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                _buildTransactionRow(
                                  'Harga Barang',
                                  _formatCurrency(transaction.itemPrice),
                                ),
                                _buildTransactionRow(
                                  'Jumlah',
                                  '${transaction.quantity} pcs',
                                ),
                                _buildTransactionRow(
                                  'Total Harga',
                                  _formatCurrency(transaction.totalPrice),
                                  isHighlight: true,
                                ),
                                const Divider(),
                                _buildTransactionRow(
                                  'Uang Pembayaran',
                                  _formatCurrency(transaction.paymentAmount),
                                ),
                                _buildTransactionRow(
                                  'Uang Kembalian',
                                  _formatCurrency(transaction.changeAmount),
                                  isHighlight: true,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isHighlight ? Colors.green : Colors.grey.shade700,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
