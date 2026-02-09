# Implementation Plan

- [x] 1. Set up Flutter project structure and dependencies




  - Create Flutter project with proper directory structure (models, services, pages, widgets)
  - Add required dependencies to pubspec.yaml (hive, hive_flutter, intl, path_provider)
  - Add dev dependencies (hive_generator, build_runner)
  - _Requirements: 8.1, 8.2, 8.3_



- [ ] 2. Implement Transaction data model with Hive adapter
  - Create Transaction model class with all required fields (id, itemPrice, paymentAmount, changeAmount, transactionDate)
  - Add Hive annotations for type adapter generation
  - Generate Hive adapter using build_runner
  - _Requirements: 2.1, 2.2, 7.2_

- [x]* 2.1 Write property test for Transaction model


  - **Property 4: Transaction completeness**
  - **Validates: Requirements 2.1, 2.2**

- [ ] 3. Implement CalculatorService for change calculation
  - Create CalculatorService class with calculateChange method
  - Implement isValidPayment validation method
  - Handle edge cases (negative values, payment less than price)
  - _Requirements: 1.3, 1.4_

- [ ]* 3.1 Write property test for change calculation
  - **Property 2: Change calculation correctness**
  - **Validates: Requirements 1.3**



- [ ]* 3.2 Write property test for payment validation
  - **Property 3: Invalid payment rejection**
  - **Validates: Requirements 1.4**

- [ ] 4. Implement TransactionService for database operations
  - Create TransactionService class
  - Implement saveTransaction method with Hive persistence
  - Implement getAllTransactions method
  - Implement getTransactionsByDay filtering method
  - Implement getTransactionsByMonth filtering method
  - Implement calculateTotal method for sum calculation
  - Add error handling for database operations
  - _Requirements: 2.3, 2.4, 3.1, 4.1, 5.1, 6.1, 7.1, 7.3_

- [ ]* 4.1 Write property test for transaction persistence
  - **Property 5: Transaction persistence round-trip**
  - **Validates: Requirements 2.3, 7.2, 7.3**

- [ ]* 4.2 Write property test for complete retrieval
  - **Property 6: Complete retrieval**
  - **Validates: Requirements 3.1**

- [x]* 4.3 Write property test for date filtering


  - **Property 8: Date-based filtering correctness**
  - **Validates: Requirements 4.1, 5.1**

- [ ]* 4.4 Write property test for total calculation
  - **Property 10: Total calculation correctness**
  - **Validates: Requirements 6.1**

- [ ] 5. Create CalculatorPage UI
  - Build calculator page layout with Material Design
  - Add input fields for item price and payment amount
  - Implement real-time change calculation display
  - Add save transaction button
  - Implement input validation and error messages
  - Handle transaction completion and navigation
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 2.2, 2.3_



- [ ]* 5.1 Write property test for input value storage
  - **Property 1: Input value storage**
  - **Validates: Requirements 1.1, 1.2**

- [ ]* 5.2 Write unit tests for CalculatorPage widget
  - Test widget rendering with sample data
  - Test button interactions
  - Test error message display

- [ ] 6. Create SalesReportPage UI
  - Build sales report page layout with transaction list
  - Implement transaction card widget for list items
  - Add filter UI components (day and month pickers)
  - Display total sales amount at the top
  - Implement empty state message
  - Format currency and dates using intl package
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 4.1, 4.2, 4.3, 4.4, 5.1, 5.2, 5.3, 5.4, 6.1, 6.2, 6.3, 6.4_

- [ ]* 6.1 Write property test for transaction ordering
  - **Property 7: Transaction ordering**
  - **Validates: Requirements 3.4**

- [ ]* 6.2 Write property test for filter reset
  - **Property 9: Filter reset restores original state**


  - **Validates: Requirements 4.4, 5.4**

- [ ]* 6.3 Write property test for currency formatting
  - **Property 11: Currency formatting consistency**
  - **Validates: Requirements 6.4**


- [ ]* 6.4 Write unit tests for SalesReportPage widget
  - Test transaction list rendering
  - Test filter interactions
  - Test empty state display



- [ ] 7. Initialize Hive database in main.dart
  - Add Hive initialization code in main() function
  - Register Transaction adapter
  - Open transactions box


  - Handle initialization errors
  - Set up app navigation structure
  - _Requirements: 7.1, 7.4_

- [ ] 8. Implement navigation between pages
  - Create bottom navigation bar or drawer
  - Wire up navigation to CalculatorPage and SalesReportPage
  - Ensure proper state management across navigation
  - _Requirements: 8.3_



- [ ] 9. Add date formatting utilities
  - Create helper functions for date formatting using intl package
  - Implement Indonesian locale formatting
  - Add currency formatting helper
  - _Requirements: 6.4, 8.4_

- [ ] 10. Final integration and polish
  - Test complete user flow from calculation to report viewing
  - Verify all filters work correctly
  - Ensure error handling works throughout the app
  - Polish UI/UX details (spacing, colors, feedback)
  - _Requirements: All_

- [ ]* 10.1 Write integration tests for complete user flows
  - Test full transaction creation and retrieval flow
  - Test filtering and total calculation flow

- [ ] 11. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise
