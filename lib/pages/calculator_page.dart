import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/cart_item.dart';
import '../services/calculator_service.dart';
import '../services/transaction_service.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _itemPriceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _paymentAmountController = TextEditingController();
  final _calculatorService = CalculatorService();
  final _transactionService = TransactionService();

  final List<CartItem> _cartItems = [];
  double? _changeAmount;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _itemPriceController.dispose();
    _quantityController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final itemPriceText = _itemPriceController.text.trim();
    final quantityText = _quantityController.text.trim();

    if (itemPriceText.isEmpty || quantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan harga dan jumlah barang'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final itemPrice = double.tryParse(itemPriceText);
    final quantity = int.tryParse(quantityText);

    if (itemPrice == null || quantity == null || quantity < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nilai yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _cartItems.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          itemPrice: itemPrice,
          quantity: quantity,
        ),
      );
      _itemPriceController.clear();
      _quantityController.text = '1';
      _changeAmount = null;
      _errorMessage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _changeAmount = null;
      _errorMessage = null;
    });
  }

  double get _cartTotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void _calculateChange() {
    setState(() {
      _errorMessage = null;
      _changeAmount = null;
    });

    if (_cartItems.isEmpty) {
      setState(() {
        _errorMessage = 'Keranjang masih kosong';
      });
      return;
    }

    final paymentAmountText = _paymentAmountController.text.trim();

    if (paymentAmountText.isEmpty) {
      setState(() {
        _errorMessage = 'Masukkan uang pembayaran';
      });
      return;
    }

    final paymentAmount = double.tryParse(paymentAmountText);

    if (paymentAmount == null) {
      setState(() {
        _errorMessage = 'Masukkan nilai yang valid';
      });
      return;
    }

    final totalPrice = _cartTotal;

    if (!_calculatorService.isValidPayment(totalPrice, paymentAmount)) {
      setState(() {
        _errorMessage = 'Uang pembayaran kurang dari total harga';
      });
      return;
    }

    final change = _calculatorService.calculateChange(
      totalPrice,
      paymentAmount,
    );
    setState(() {
      _changeAmount = change;
    });
  }

  Future<void> _saveTransaction() async {
    if (_cartItems.isEmpty || _changeAmount == null) {
      return;
    }

    final paymentAmountText = _paymentAmountController.text.trim();
    if (paymentAmountText.isEmpty) {
      return;
    }

    final paymentAmount = double.parse(paymentAmountText);

    setState(() {
      _isLoading = true;
    });

    try {
      // Save each cart item as a separate transaction
      for (final item in _cartItems) {
        final transaction = Transaction(
          id: '${DateTime.now().millisecondsSinceEpoch}_${item.id}',
          itemPrice: item.itemPrice,
          quantity: item.quantity,
          paymentAmount: paymentAmount / _cartItems.length,
          changeAmount: _changeAmount! / _cartItems.length,
          transactionDate: DateTime.now(),
        );
        await _transactionService.saveTransaction(transaction);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaksi berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        setState(() {
          _cartItems.clear();
          _paymentAmountController.clear();
          _changeAmount = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan transaksi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Kembalian'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Item Price Input
            TextField(
              controller: _itemPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga Barang (per item)',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_changeAmount != null) {
                  _calculateChange();
                }
              },
            ),
            const SizedBox(height: 16),

            // Quantity Input
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Barang',
                border: OutlineInputBorder(),
                suffixText: 'pcs',
              ),
              onChanged: (_) {
                if (_changeAmount != null) {
                  _calculateChange();
                }
              },
            ),
            const SizedBox(height: 16),

            // Add to Cart Button
            ElevatedButton.icon(
              onPressed: _addToCart,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text(
                'Tambah ke Keranjang',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Cart Items List
            if (_cartItems.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Keranjang Belanja',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_cartItems.length} item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              _formatCurrency(item.itemPrice),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('${item.quantity} pcs'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatCurrency(item.totalPrice),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeFromCart(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Belanja:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatCurrency(_cartTotal),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Payment Amount Input
            TextField(
              controller: _paymentAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Uang Pembayaran',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_changeAmount != null) {
                  _calculateChange();
                }
              },
            ),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton(
              onPressed: _calculateChange,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Hitung Kembalian',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Change Amount Display
            if (_changeAmount != null && _errorMessage == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Uang Kembalian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatCurrency(_changeAmount!),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

            // Save Transaction Button
            if (_changeAmount != null && _errorMessage == null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveTransaction,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Transaksi'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
