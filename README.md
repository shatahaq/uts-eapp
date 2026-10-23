# Medan Smart Tourism (Demo UI Flutter)

Tampilan lengkap alur: Login -> Beranda -> Detail Wisata -> Pilih Tanggal/Sesi/Jumlah -> Pembayaran -> Berhasil -> E-Tiket (QR) -> Antrian realtime (simulasi).
Plus layar Petugas (scan QR simulasi) dan Admin (dashboard).

## Cara menjalankan
Lingkungan komputer ini sudah disiapkan dengan Flutter 3.47.7, Dart 3.13.5,
Git dari Laragon, serta ekstensi Flutter dan Dart di VS Code.
Flutter SDK berada di `C:\Users\usudl\develop\flutter`.

1. Buka ulang terminal atau VS Code agar PATH yang baru terbaca.
2. Buka terminal di folder proyek ini.
3. Jalankan `flutter pub get` jika dependensi belum tersedia.
4. Jalankan `flutter run -d chrome` untuk membuka aplikasi di Chrome.

Berkas platform web sudah tersedia; tidak perlu membuat proyek baru atau menyalin kode.
Untuk memeriksa proyek: `flutter test` dan `flutter analyze`.
Untuk membuat hasil build web: `flutter build web` (hasil di `build/web`).

## Menjalankan di Android

Android Studio berada di `%LOCALAPPDATA%\Programs\Android\android-studio`
dan dapat dibuka melalui Start Menu. Android SDK berada di
`%LOCALAPPDATA%\Android\Sdk`; Flutter sudah diarahkan ke SDK dan Java bawaan
Android Studio. Buka ulang terminal atau VS Code agar variabel lingkungan terbaca.

SDK Android API 35/36, Build Tools 36, NDK, CMake, platform-tools, dan emulator
Android 16 (API 36) sudah dipasang. Lisensi SDK sudah diterima.
Proyek ditandai agar selalu tersedia secara lokal di OneDrive, dan konfigurasi
Gradle menggunakan akses berkas Java untuk menghindari masalah placeholder OneDrive.

1. Jalankan `flutter emulators` untuk melihat emulator yang tersedia.
2. Jalankan `flutter emulators --launch Medan_API_36` untuk menyalakan emulator.
3. Tunggu Android selesai menyala, lalu jalankan `flutter devices`.
4. Jalankan `flutter run -d <ID_ANDROID>` menggunakan ID dari perintah sebelumnya.

Untuk menggunakan HP, aktifkan Developer options dan USB debugging, sambungkan
dengan USB, lalu izinkan debugging di HP. Periksa deteksi dengan `flutter devices`.

Untuk membuat APK uji: `flutter build apk --debug`.
Hasilnya berada di `build/app/outputs/flutter-apk/app-debug.apk`.
Untuk memeriksa toolchain: `flutter doctor -v`.

Aplikasi desktop Windows memerlukan Visual Studio dengan workload
Desktop development with C++; toolchain desktop tersebut belum dipasang.

## Cara mencoba semua layar
- Di layar login pilih peran "Wisatawan / Petugas / Admin" (khusus demo), isi email apa saja + password minimal 4 huruf.
- Kode promo contoh: MEDAN10
- Tiket yang dipesan untuk HARI INI bisa langsung ambil nomor antrian (nomor maju otomatis tiap 4 detik).

## Struktur
lib/main.dart, theme.dart (warna), data.dart (data contoh), widgets.dart (komponen), screens/ (semua layar)

## UI dan pengalaman pengguna
- Palet hijau tua dan putih hangat, font Plus Jakarta Sans untuk antarmuka, DM Serif Display untuk judul.
- Foto destinasi dan font dibundel di `assets/`; tampilan tidak memerlukan unduhan font/foto saat dijalankan.
- Pencarian dan kategori memfilter seluruh hasil. Destinasi tersimpan dapat dibuka melalui ikon simpan dan Profil.
- Pemilihan tanggal memakai date picker ringkas; sesi penuh dinonaktifkan dan jumlah pengunjung dibatasi kuota.
- Total sejak pemesanan sudah mencakup biaya layanan. Promo MEDAN10 maksimal sebesar subtotal tiket.
- Akun, pembayaran, antrean, dan dashboard masih menggunakan data sesi/demo, bukan layanan backend.
- Kredit dan lisensi aset tersedia di `assets/ATTRIBUTION.md` dan menu Kredit foto & font.

## Langkah berikutnya
- Ganti data contoh di data.dart dengan Supabase (supabase_flutter).
- Ganti simulasi kamera di staff_screen.dart dengan paket mobile_scanner.
- Hubungkan status ketersediaan, pembayaran, dan akun dengan backend sebelum digunakan untuk transaksi nyata.
