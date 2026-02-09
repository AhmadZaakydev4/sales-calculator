# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-02-09

### Added
- Kalkulator uang kembalian dengan validasi input
- Penyimpanan transaksi ke database lokal (Hive)
- Halaman laporan penjualan dengan daftar transaksi
- Filter transaksi berdasarkan hari
- Filter transaksi berdasarkan bulan
- Perhitungan total penjualan otomatis
- Format currency dalam Rupiah Indonesia
- Format tanggal dalam Bahasa Indonesia
- Bottom navigation untuk navigasi antar halaman
- Error handling untuk operasi database
- Pull-to-refresh pada halaman laporan
- Empty state messages
- Loading indicators

### Features
- **Calculator Page**: Input harga barang dan uang pembayaran, hitung kembalian otomatis
- **Sales Report Page**: Lihat riwayat transaksi dengan filter dan total penjualan
- **Local Storage**: Data tersimpan secara lokal tanpa memerlukan internet
- **Indonesian Locale**: Format currency dan tanggal dalam Bahasa Indonesia

### Technical
- Clean architecture dengan separation of concerns
- Hive database untuk local storage
- Material Design 3 UI components
- StatefulWidget untuk state management
- Error handling dan user feedback
