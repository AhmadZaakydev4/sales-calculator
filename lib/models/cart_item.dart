class CartItem {
  final String id;
  final double itemPrice;
  final int quantity;

  CartItem({required this.id, required this.itemPrice, required this.quantity});

  double get totalPrice => itemPrice * quantity;

  CartItem copyWith({String? id, double? itemPrice, int? quantity}) {
    return CartItem(
      id: id ?? this.id,
      itemPrice: itemPrice ?? this.itemPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
