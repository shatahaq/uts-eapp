import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'ticket_screen.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});
  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final t = appState.activeQueue;
      if (t != null && t.calledNo < t.queueNo!) {
        t.calledNo++;
        appState.tick();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
            child:
                Text('Antrean saya', style: editorial.copyWith(fontSize: 34))),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('Tunggu dengan tenang, pantau dari sini.',
                style: TextStyle(fontSize: 12, color: C.textSecondary))),
        const SizedBox(height: 12),
        Expanded(
            child: ListenableBuilder(
                listenable: appState,
                builder: (_, __) {
                  final t = appState.activeQueue;
                  if (t == null) {
                    return EmptyState(
                        icon: Icons.hourglass_empty_rounded,
                        title: 'Belum masuk antrean',
                        message:
                            'Pada hari kunjungan, buka e-tiket lalu ambil nomor antrean. Nomormu akan muncul di sini.',
                        buttonText: 'Buka tiket saya',
                        onButton: () => tabIndex.value = 1);
                  }
                  final difference = max(0, t.queueNo! - t.calledNo);
                  final called = difference == 0;
                  return ListView(padding: const EdgeInsets.all(24), children: [
                    Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            color: C.primary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(children: [
                          Text(t.dest.name,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white70)),
                          const SizedBox(height: 24),
                          const Text('NOMOR ANTREANMU',
                              style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 2,
                                  color: Colors.white70)),
                          const SizedBox(height: 10),
                          Text(t.queueLabel,
                              style: const TextStyle(
                                  fontSize: 62,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -2)),
                          const SizedBox(height: 20),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                  called
                                      ? 'Giliranmu · menuju Loket 2'
                                      : 'Menunggu giliran',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600))),
                        ])),
                    const SizedBox(height: 16),
                    SoftCard(
                        child: Column(children: [
                      InfoRow('Sedang dipanggil', t.calledLabel, bold: true),
                      const Divider(height: 22),
                      InfoRow('Antrean di depan',
                          '${max(0, difference - 1)} pengunjung'),
                      InfoRow(
                          'Estimasi tunggu',
                          called
                              ? 'Silakan masuk'
                              : '± ${difference * 2} menit'),
                    ])),
                    const SizedBox(height: 20),
                    const Text('SIMULASI ANTREAN',
                        style: TextStyle(
                            fontSize: 9,
                            color: C.textSecondary,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text(
                        'Nomor bergerak otomatis setiap 4 detik untuk pratinjau. Tetap berada di sekitar pintu masuk saat giliranmu mendekat.',
                        style: TextStyle(
                            fontSize: 11, height: 1.8, color: C.textSecondary)),
                    const SizedBox(height: 24),
                    PrimaryButton(
                        label: 'Tampilkan e-tiket',
                        icon: Icons.qr_code_2_rounded,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TicketScreen(ticket: t)))),
                    const SizedBox(height: 12),
                    TextButton(
                        onPressed: () async {
                          final cancel = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                    title: const Text('Keluar dari antrean?'),
                                    content: const Text(
                                        'Nomor antrean akan dihapus. E-tiket tetap aktif.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(c, false),
                                          child: const Text('Tetap menunggu')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(c, true),
                                          child: const Text('Keluar antrean',
                                              style: TextStyle(color: C.error)))
                                    ],
                                  ));
                          if (cancel == true) appState.cancelQueue(t);
                        },
                        child: const Text('Keluar dari antrean',
                            style: TextStyle(color: C.error))),
                  ]);
                })),
      ]));
}
