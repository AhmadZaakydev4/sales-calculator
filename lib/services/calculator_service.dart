class CalculatorService {
  /// Calculate change amount from item price and payment amount
  /// Returns the difference between payment and price
  double calculateChange(double itemPrice, double paymentAmount) {
    return paymentAmount - itemPrice;
  }

  /// Validate if payment amount is sufficient for the item price
  /// Returns true if payment >= price, false otherwise
  bool isValidPayment(double itemPrice, double paymentAmount) {
    // Check for negative values
    if (itemPrice < 0 || paymentAmount < 0) {
      return false;
    }
    
    // Check if payment is sufficient
    return paymentAmount >= itemPrice;
  }
}
