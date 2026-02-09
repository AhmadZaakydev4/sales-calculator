# Requirements Document

## Introduction

Aplikasi mobile Flutter untuk menghitung pembelian barang dan melacak hasil dagang. Aplikasi ini memungkinkan pengguna untuk menghitung uang kembalian dari transaksi pembelian, menyimpan riwayat transaksi, dan menganalisis hasil dagang berdasarkan periode waktu tertentu.

## Glossary

- **Sales Calculator App**: Aplikasi mobile yang dibangun dengan Flutter untuk menghitung pembelian dan hasil dagang
- **Transaction**: Catatan pembelian yang berisi harga barang, uang pembayaran, uang kembalian, dan tanggal transaksi
- **Change Amount**: Selisih antara uang pembayaran dan harga barang (uang kembalian)
- **Sales Report**: Laporan yang menampilkan daftar transaksi dan total hasil dagang
- **Local Database**: Hive database yang menyimpan data transaksi secara lokal di perangkat
- **Filter**: Mekanisme untuk menyaring transaksi berdasarkan hari atau bulan tertentu

## Requirements

### Requirement 1

**User Story:** As a kasir, I want to calculate the change amount for a purchase, so that I can quickly determine how much money to return to the customer

#### Acceptance Criteria

1. WHEN a user enters an item price, THE Sales Calculator App SHALL accept and store the price value
2. WHEN a user enters a payment amount, THE Sales Calculator App SHALL accept and store the payment value
3. WHEN both item price and payment amount are entered, THE Sales Calculator App SHALL calculate the change amount as the difference between payment and price
4. IF the payment amount is less than the item price, THEN THE Sales Calculator App SHALL display an error message and prevent transaction completion
5. WHEN the change amount is calculated, THE Sales Calculator App SHALL display the result to the user immediately

### Requirement 2

**User Story:** As a kasir, I want to save each transaction automatically, so that I can track all sales without manual record keeping

#### Acceptance Criteria

1. WHEN a transaction is completed, THE Sales Calculator App SHALL create a Transaction record with item price, payment amount, change amount, and current date
2. WHEN creating a Transaction record, THE Sales Calculator App SHALL automatically capture the current day and month as the transaction date
3. WHEN a Transaction is created, THE Sales Calculator App SHALL persist the data to the Local Database immediately
4. WHEN saving to the Local Database, THE Sales Calculator App SHALL ensure data integrity and handle any storage errors gracefully

### Requirement 3

**User Story:** As a pemilik toko, I want to view a list of all transactions, so that I can review the sales history

#### Acceptance Criteria

1. WHEN a user navigates to the sales report page, THE Sales Calculator App SHALL retrieve all Transaction records from the Local Database
2. WHEN displaying transactions, THE Sales Calculator App SHALL show item price, payment amount, change amount, and transaction date for each Transaction
3. WHEN the transaction list is empty, THE Sales Calculator App SHALL display an appropriate message indicating no transactions exist
4. WHEN transactions are displayed, THE Sales Calculator App SHALL order them by date with the most recent first

### Requirement 4

**User Story:** As a pemilik toko, I want to filter transactions by day, so that I can analyze daily sales performance

#### Acceptance Criteria

1. WHEN a user selects a specific day filter, THE Sales Calculator App SHALL display only Transaction records matching that day
2. WHEN the day filter is applied, THE Sales Calculator App SHALL update the displayed transaction list immediately
3. WHEN no transactions match the selected day, THE Sales Calculator App SHALL display a message indicating no results found
4. WHEN the day filter is cleared, THE Sales Calculator App SHALL restore the full transaction list

### Requirement 5

**User Story:** As a pemilik toko, I want to filter transactions by month, so that I can analyze monthly sales performance

#### Acceptance Criteria

1. WHEN a user selects a specific month filter, THE Sales Calculator App SHALL display only Transaction records matching that month
2. WHEN the month filter is applied, THE Sales Calculator App SHALL update the displayed transaction list immediately
3. WHEN no transactions match the selected month, THE Sales Calculator App SHALL display a message indicating no results found
4. WHEN the month filter is cleared, THE Sales Calculator App SHALL restore the full transaction list

### Requirement 6

**User Story:** As a pemilik toko, I want to see the total sales amount based on my selected filter, so that I can understand revenue for specific periods

#### Acceptance Criteria

1. WHEN transactions are displayed with a filter applied, THE Sales Calculator App SHALL calculate the sum of all item prices in the filtered results
2. WHEN the filter changes, THE Sales Calculator App SHALL recalculate the total sales amount immediately
3. WHEN no transactions match the filter, THE Sales Calculator App SHALL display a total of zero
4. WHEN displaying the total, THE Sales Calculator App SHALL format the amount in a clear and readable currency format

### Requirement 7

**User Story:** As a developer, I want the application to use Hive for local storage, so that transaction data persists across app sessions without requiring internet connectivity

#### Acceptance Criteria

1. WHEN the Sales Calculator App initializes, THE Sales Calculator App SHALL initialize the Hive database
2. WHEN storing Transaction data, THE Sales Calculator App SHALL use Hive adapters to serialize and deserialize Transaction objects
3. WHEN the app is closed and reopened, THE Sales Calculator App SHALL retrieve all previously saved transactions from Hive
4. WHEN database operations fail, THE Sales Calculator App SHALL log errors and provide user feedback

### Requirement 8

**User Story:** As a developer, I want the codebase to follow clean architecture principles, so that the application is maintainable and testable

#### Acceptance Criteria

1. WHEN organizing code files, THE Sales Calculator App SHALL separate models, pages, and business logic into distinct directories
2. WHEN implementing features, THE Sales Calculator App SHALL use data models to represent Transaction entities
3. WHEN building UI components, THE Sales Calculator App SHALL separate presentation logic from business logic
4. WHEN implementing date handling, THE Sales Calculator App SHALL use the intl package for consistent date formatting
