# Design Document

## Overview

Aplikasi Sales Calculator adalah aplikasi mobile Flutter yang memungkinkan kasir untuk menghitung uang kembalian dan pemilik toko untuk melacak hasil dagang. Aplikasi ini menggunakan arsitektur yang bersih dengan pemisahan antara data layer, business logic, dan presentation layer. Data transaksi disimpan secara lokal menggunakan Hive database untuk memastikan persistensi data tanpa memerlukan koneksi internet.

## Architecture

Aplikasi menggunakan arsitektur berlapis dengan struktur sebagai berikut:

```
lib/
├── models/          # Data models dan Hive adapters
├── services/        # Business logic dan database operations
├── pages/           # UI screens
├── widgets/         # Reusable UI components
└── main.dart        # Entry point aplikasi
```

### Layer Responsibilities:

1. **Models Layer**: Mendefinisikan struktur data Transaction dan type adapters untuk Hive
2. **Services Layer**: Mengelola operasi database, kalkulasi, dan filtering logic
3. **Pages Layer**: Menampilkan UI dan menangani user interactions
4. **Widgets Layer**: Komponen UI yang dapat digunakan kembali

## Components and Interfaces

### 1. Transaction Model

```dart
class Transaction {
  final String id;
  final double itemPrice;
  final double paymentAmount;
  final double changeAmount;
  final DateTime transactionDate;
}
```

### 2. TransactionService

Interface untuk mengelola operasi transaksi:

```dart
class TransactionService {
  Future<void> saveTransaction(Transaction transaction);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsByDay(DateTime day);
  Future<List<Transaction>> getTransactionsByMonth(int year, int month);
  double calculateTotal(List<Transaction> transactions);
}
```

### 3. CalculatorService

Interface untuk kalkulasi pembelian:

```dart
class CalculatorService {
  double calculateChange(double itemPrice, double paymentAmount);
  bool isValidPayment(double itemPrice, double paymentAmount);
}
```

### 4. UI Pages

- **CalculatorPage**: Halaman untuk input harga barang dan uang pembayaran
- **SalesReportPage**: Halaman untuk menampilkan daftar transaksi dengan filter

## Data Models

### Transaction Model

```dart
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
  
  Transaction({
    required this.id,
    required this.itemPrice,
    required this.paymentAmount,
    required this.changeAmount,
    required this.transactionDate,
  });
}
```

### Database Schema

Hive box structure:
- Box name: `transactions`
- Key: Auto-generated integer
- Value: Transaction object

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property Reflection

After reviewing the prework analysis, I've identified the following consolidations:

**Redundancies to address:**
- Properties 1.1 and 1.2 (storing price and payment) can be combined into one property about state management
- Properties 4.2 and 5.2 (filter updates list immediately) are redundant with 4.1 and 5.1 - if filtering returns correct results, the update is implicit
- Properties 6.2 is redundant with 6.1 - if total calculation is correct for any filtered set, recalculation on filter change is implicit
- Property 2.4 (data integrity) is covered by property 2.3 (round-trip persistence)

**Properties to combine:**
- Day filter (4.1) and month filter (5.1) can be generalized into a single property about date-based filtering
- Filter clearing (4.4 and 5.4) can be combined into one property about filter reset behavior

### Correctness Properties

Property 1: Input value storage
*For any* valid price or payment amount entered by the user, the application state should correctly store and retrieve that exact value
**Validates: Requirements 1.1, 1.2**

Property 2: Change calculation correctness
*For any* item price P and payment amount M where M >= P, the calculated change amount should equal (M - P)
**Validates: Requirements 1.3**

Property 3: Invalid payment rejection
*For any* item price P and payment amount M where M < P, the system should reject the transaction and prevent completion
**Validates: Requirements 1.4**

Property 4: Transaction completeness
*For any* completed transaction, the created Transaction record should contain all required fields: item price, payment amount, change amount, and transaction date
**Validates: Requirements 2.1, 2.2**

Property 5: Transaction persistence round-trip
*For any* Transaction object, saving it to the database and then retrieving it should produce an equivalent Transaction with all fields preserved
**Validates: Requirements 2.3, 7.2, 7.3**

Property 6: Complete retrieval
*For any* set of N transactions saved to the database, retrieving all transactions should return exactly N transactions
**Validates: Requirements 3.1**

Property 7: Transaction ordering
*For any* list of transactions with different dates, when displayed, they should be ordered with the most recent transaction first
**Validates: Requirements 3.4**

Property 8: Date-based filtering correctness
*For any* set of transactions and any date filter (day or month), the filtered results should contain only transactions whose date matches the filter criteria
**Validates: Requirements 4.1, 5.1**

Property 9: Filter reset restores original state
*For any* transaction list, applying a filter and then clearing it should return the complete original list
**Validates: Requirements 4.4, 5.4**

Property 10: Total calculation correctness
*For any* list of transactions (filtered or unfiltered), the calculated total should equal the sum of all item prices in that list
**Validates: Requirements 6.1**

Property 11: Currency formatting consistency
*For any* numeric amount, the formatted currency string should follow a consistent, readable format
**Validates: Requirements 6.4**

## Error Handling

### Input Validation Errors
- **Insufficient Payment**: When payment < item price, display error message "Uang pembayaran kurang dari harga barang"
- **Invalid Input**: When non-numeric or negative values are entered, display error message "Masukkan nilai yang valid"
- **Empty Input**: When required fields are empty, disable transaction completion button

### Database Errors
- **Initialization Failure**: If Hive fails to initialize, log error and display message "Gagal menginisialisasi database"
- **Save Failure**: If transaction save fails, log error and display message "Gagal menyimpan transaksi"
- **Retrieve Failure**: If data retrieval fails, log error and display empty list with message "Gagal memuat data transaksi"

### Error Recovery
- All errors should be logged for debugging
- User should receive clear feedback about what went wrong
- Application should remain in a stable state after errors
- Failed transactions should not corrupt existing data

## Testing Strategy

### Property-Based Testing Framework
The application will use the **flutter_test** package with custom property-based testing utilities. Since Dart/Flutter doesn't have a mature property-based testing library like QuickCheck or Hypothesis, we will implement lightweight property testing helpers that:
- Generate random test data (prices, payments, dates)
- Run each property test with a minimum of 100 iterations
- Verify properties hold across all generated inputs

### Unit Testing Approach

Unit tests will cover:
- **CalculatorService**: Test specific examples of change calculation (e.g., 10000 payment - 7500 price = 2500 change)
- **TransactionService**: Test database operations with sample transactions
- **Date Filtering**: Test edge cases like month boundaries, leap years
- **UI Widgets**: Test widget rendering with sample data

### Property-Based Testing Approach

Property tests will verify universal behaviors:
- **Property 2 (Change calculation)**: Generate 100+ random price/payment pairs, verify change = payment - price
- **Property 5 (Persistence round-trip)**: Generate 100+ random transactions, verify save/load preserves all fields
- **Property 8 (Filtering)**: Generate 100+ random transaction sets with various dates, verify filters return only matching records
- **Property 10 (Total calculation)**: Generate 100+ random transaction lists, verify sum is correct

### Test Organization
- Unit tests: `test/unit/` directory
- Property tests: `test/properties/` directory
- Widget tests: `test/widgets/` directory
- Each test file should be co-located with its source file using `_test.dart` suffix when appropriate

### Test Tagging
Each property-based test MUST include a comment tag in this format:
```dart
// **Feature: flutter-sales-calculator, Property X: [property description]**
```

This ensures traceability between design properties and test implementations.

## UI/UX Design

### Calculator Page
- Clean, simple interface with two input fields
- Large, clear buttons for number input
- Real-time display of change amount
- Material Design components for consistency
- Error messages displayed prominently when validation fails

### Sales Report Page
- List view of all transactions with card-based layout
- Filter chips for day and month selection
- Total sales amount displayed at the top
- Empty state message when no transactions exist
- Pull-to-refresh functionality
- Date picker for easy filter selection

### Navigation
- Bottom navigation bar or drawer for switching between Calculator and Sales Report
- Clear visual indication of current page

### Formatting
- Currency amounts formatted with thousand separators (e.g., "Rp 1.000.000")
- Dates formatted in Indonesian locale (e.g., "9 Februari 2026")
- Consistent spacing and padding throughout

## Dependencies

### Required Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.18.0
  path_provider: ^2.0.15

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
```

### Package Justifications
- **hive & hive_flutter**: Fast, lightweight NoSQL database for local storage
- **intl**: Internationalization and date formatting
- **path_provider**: Access to device file system for Hive storage
- **hive_generator & build_runner**: Code generation for Hive type adapters

## Implementation Notes

### State Management
Use StatefulWidget with setState for simple state management. For a small app like this, complex state management solutions (Provider, Riverpod, Bloc) are not necessary.

### Database Initialization
Initialize Hive in main() before runApp():
```dart
await Hive.initFlutter();
Hive.registerAdapter(TransactionAdapter());
await Hive.openBox<Transaction>('transactions');
```

### Date Handling
Use DateTime for all date operations. Store full DateTime in database but extract day/month for filtering:
```dart
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
```

### Performance Considerations
- Hive is fast enough for thousands of transactions
- Filtering operations should be done in-memory (acceptable for typical usage)
- If performance becomes an issue, consider indexing by date or using lazy loading
