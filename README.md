# Sales Calculator

Aplikasi mobile Flutter untuk menghitung pembelian barang dan melacak hasil dagang.

## Fitur

- ✅ Kalkulator uang kembalian
- ✅ Penyimpanan riwayat transaksi
- ✅ Filter transaksi berdasarkan hari atau bulan
- ✅ Laporan total penjualan
- ✅ Penyimpanan data lokal dengan Hive
- ✅ Format currency dan tanggal dalam Bahasa Indonesia

## Struktur Project

```
lib/
├── models/          # Data models dan Hive adapters
│   ├── transaction.dart
│   └── transaction.g.dart (generated)
├── services/        # Business logic dan database operations
│   ├── calculator_service.dart
│   └── transaction_service.dart
├── pages/           # UI screens
│   ├── calculator_page.dart
│   └── sales_report_page.dart
├── utils/           # Utility functions
│   ├── date_formatter.dart
│   └── currency_formatter.dart
└── main.dart        # Entry point aplikasi

test/
├── unit/            # Unit tests
├── properties/      # Property-based tests
└── widgets/         # Widget tests
```

## Setup

1. Install dependencies:
```bash
cd sales_calculator
flutter pub get
```

2. Run aplikasi:
```bash
flutter run
```

Untuk menjalankan di device/emulator tertentu:
```bash
flutter devices  # Lihat daftar devices
flutter run -d <device_id>
```

## Cara Menggunakan

### Halaman Kalkulator
1. Masukkan harga barang
2. Masukkan uang pembayaran
3. Klik "Hitung Kembalian"
4. Jika valid, uang kembalian akan ditampilkan
5. Klik "Simpan Transaksi" untuk menyimpan ke database

### Halaman Laporan
1. Lihat semua transaksi yang tersimpan
2. Gunakan "Filter Hari" untuk melihat transaksi hari tertentu
3. Gunakan "Filter Bulan" untuk melihat transaksi bulan tertentu
4. Total penjualan ditampilkan di bagian atas
5. Pull down untuk refresh data

## Dependencies

- **hive & hive_flutter**: Local database
- **intl**: Date and currency formatting
- **path_provider**: File system access
- **hive_generator & build_runner**: Code generation

## Requirements

- Flutter SDK 3.10.8 atau lebih tinggi
- Dart SDK 3.10.8 atau lebih tinggi

## Dokumentasi

Lihat folder `.kiro/specs/flutter-sales-calculator/` untuk:
- `requirements.md` - Spesifikasi requirements
- `design.md` - Design document
- `tasks.md` - Implementation plan

## Troubleshooting

### Error saat build
Jika ada error saat build, coba:
```bash
flutter clean
flutter pub get
```

### Data tidak tersimpan
Pastikan Hive sudah diinisialisasi dengan benar di `main.dart`

### Format tanggal tidak sesuai
Pastikan Indonesian locale sudah diinisialisasi di `DateFormatter.initialize()`

