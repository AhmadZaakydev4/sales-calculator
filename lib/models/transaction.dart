import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double itemPrice;

  @HiveField(2)
  final double paymentAmount;

  @HiveField(3)
  final double changeAmount;

  @HiveField(4)
  final DateTime transactionDate;

  @HiveField(5)
  final int quantity;

  Transaction({
    required this.id,
    required this.itemPrice,
    required this.paymentAmount,
    required this.changeAmount,
    required this.transactionDate,
    this.quantity = 1,
  });

  double get totalPrice => itemPrice * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.itemPrice == itemPrice &&
        other.paymentAmount == paymentAmount &&
        other.changeAmount == changeAmount &&
        other.transactionDate == transactionDate &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemPrice.hashCode ^
        paymentAmount.hashCode ^
        changeAmount.hashCode ^
        transactionDate.hashCode ^
        quantity.hashCode;
  }

  @override
  String toString() {
    return 'Transaction(id: $id, itemPrice: $itemPrice, quantity: $quantity, totalPrice: $totalPrice, paymentAmount: $paymentAmount, changeAmount: $changeAmount, transactionDate: $transactionDate)';
  }
}
