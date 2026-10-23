import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  Future<void> logout(BuildContext context) async {
    final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text('Keluar dari sesi ini?'),
              content: const Text('Kamu tetap bisa menjelajah tanpa masuk.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text('Tetap di sini')),
                TextButton(
                    onPressed: () => Navigator.pop(c, true),
                    child:
                        const Text('Keluar', style: TextStyle(color: C.error)))
              ],
            ));
    if (ok == true && context.mounted) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: ListenableBuilder(
          listenable: appState,
          builder: (_, __) => ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                children: [
                  Text('Ruang untukmu.',
                      style: editorial.copyWith(fontSize: 34)),
                  const SizedBox(height: 24),
                  Row(children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: C.primaryLight,
                        child: Text(appState.buyer[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 24,
                                color: C.primary,
                                fontWeight: FontWeight.w700))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(appState.buyer,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(
                              appState.email.isEmpty
                                  ? 'Selamat datang di Medan'
                                  : appState.email,
                              style: const TextStyle(
                                  fontSize: 11, color: C.textSecondary)),
                        ])),
                  ]),
                  const SizedBox(height: 30),
                  const Text('PERJALANAN',
                      style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: C.textSecondary,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  SoftCard(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(children: [
                        _item(
                            Icons.bookmark_border_rounded,
                            'Destinasi tersimpan',
                            '${appState.favorites.length} tempat untuk nanti',
                            () => showSavedDestinations(context)),
                        const Divider(height: 1, indent: 50, endIndent: 12),
                        _item(
                            Icons.confirmation_number_outlined,
                            'Tiket & kunjungan',
                            'Lihat rencana perjalananmu',
                            () => tabIndex.value = 1),
                      ])),
                  const SizedBox(height: 26),
                  const Text('INFORMASI',
                      style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: C.textSecondary,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  SoftCard(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(children: [
                        _item(
                            Icons.help_outline_rounded,
                            'Panduan kunjungan',
                            'Tiket, QR, dan antrean',
                            () => showInfo(context, 'Dari rencana hingga tiba',
                                '1. Pilih destinasi, tanggal, dan sesi kunjungan.\n\n2. Tentukan jumlah pengunjung dan periksa total biaya.\n\n3. Selesaikan pembayaran simulasi. E-tiket akan tersedia di Tiket Saya.\n\n4. Pada hari kunjungan, ambil nomor antrean melalui e-tiket.\n\n5. Tunjukkan kode QR kepada petugas saat dipanggil.')),
                        const Divider(height: 1, indent: 50, endIndent: 12),
                        _item(
                            Icons.info_outline_rounded,
                            'Tentang aplikasi',
                            'Medan Smart Tourism',
                            () => showInfo(context, 'Medan Smart Tourism',
                                'Temukan wisata budaya, sejarah, dan alam di Medan dan sekitarnya.\n\nVersi ini adalah pratinjau: akun, harga, ketersediaan tiket, pembayaran, serta antrean menggunakan data contoh. Data sesi tidak disimpan setelah aplikasi ditutup. Tidak ada transaksi uang atau email yang dikirim.')),
                        const Divider(height: 1, indent: 50, endIndent: 12),
                        _item(
                            Icons.photo_outlined,
                            'Kredit foto & font',
                            'Fotografer di balik perjalanan',
                            () => showPhotoCredits(context)),
                      ])),
                  const SizedBox(height: 28),
                  OutlineBtn(
                      label: 'Keluar dari sesi',
                      icon: Icons.logout_rounded,
                      onTap: () => logout(context)),
                  const SizedBox(height: 24),
                  const Text('Dibuat untuk menikmati Medan.\nVersi 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10, height: 1.8, color: C.textSecondary)),
                ],
              )));
  Widget _item(
          IconData icon, String title, String subtitle, VoidCallback action) =>
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        leading: Icon(icon, color: C.primary, size: 22),
        title: Text(title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitle,
                style: const TextStyle(fontSize: 10, color: C.textSecondary))),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: C.textSecondary, size: 19),
        onTap: action,
      );
}
