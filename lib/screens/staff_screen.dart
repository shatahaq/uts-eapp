import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login_screen.dart';

/// Layar petugas loket. Kamera dibuat sebagai simulasi.
/// Untuk kamera asli, pasang paket `mobile_scanner` lalu ganti area "kamera" di bawah.
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});
  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController line;
  bool flash = false;
  int sold = 128;
  int checkedIn = 74;

  @override
  void initState() {
    super.initState();
    line =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    line.dispose();
    super.dispose();
  }

  void showResult(String type) {
    final cfg = {
      'valid': (
        C.success,
        Icons.check_circle_rounded,
        'Tiket Valid',
        'Silakan konfirmasi check-in.'
      ),
      'used': (
        C.error,
        Icons.cancel_rounded,
        'Tiket Sudah Dipakai',
        'Check-in sebelumnya: 09.42 oleh Petugas Ani.'
      ),
      'date': (
        C.warning,
        Icons.event_busy_rounded,
        'Salah Tanggal / Sesi',
        'Jadwal tiket: 25 Mar 2026, sesi 13.00 - 15.00.'
      ),
      'unknown': (
        C.error,
        Icons.help_outline_rounded,
        'Tiket Tidak Dikenal',
        'QR tidak terdaftar atau sudah kedaluwarsa.'
      ),
    }[type]!;
    final color = cfg.$1;
    final valid = type == 'valid';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                    color: C.divider, borderRadius: BorderRadius.circular(9))),
            const SizedBox(height: 20),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                  color: color.withAlpha(30), shape: BoxShape.circle),
              child: Icon(cfg.$2, color: color, size: 52),
            ),
            const SizedBox(height: 12),
            Text(cfg.$3,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(cfg.$4,
                textAlign: TextAlign.center,
                style: const TextStyle(color: C.textSecondary)),
            if (valid) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: C.bg, borderRadius: BorderRadius.circular(16)),
                child: const Column(children: [
                  InfoRow('Pemesan', 'Budi Santoso'),
                  InfoRow('Wisata', 'Istana Maimun'),
                  InfoRow('Sesi', '10.00 - 12.00'),
                  InfoRow('Pengunjung', '2 Dewasa, 1 Anak'),
                  InfoRow('Kode', 'MST-240315-4821'),
                ]),
              ),
            ],
            const SizedBox(height: 20),
            if (valid) ...[
              PrimaryButton(
                label: 'Konfirmasi Check-in',
                color: C.success,
                icon: Icons.login_rounded,
                onTap: () {
                  Navigator.pop(c);
                  setState(() => checkedIn++);
                  toast(context, 'Check-in berhasil ✓', color: C.success);
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('Batal')),
            ] else
              PrimaryButton(label: 'Scan Lagi', onTap: () => Navigator.pop(c)),
          ]),
        ),
      ),
    );
  }

  void manualInput() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Input Kode Booking'),
        content: TextField(
          controller: ctrl,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'MST-240315-0042'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: C.primary),
            onPressed: () {
              final ok = ctrl.text.trim().toUpperCase().startsWith('MST-');
              Navigator.pop(c);
              showResult(ok ? 'valid' : 'unknown');
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
          // Bar atas
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
            child: Row(children: [
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Petugas Loket',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      Text('Istana Maimun • Loket 2',
                          style:
                              TextStyle(color: Colors.white60, fontSize: 12)),
                    ]),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (r) => false),
              ),
            ]),
          ),
          // Statistik
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Expanded(child: _stat('Terjual', '$sold')),
              const SizedBox(width: 10),
              Expanded(child: _stat('Check-in', '$checkedIn')),
              const SizedBox(width: 10),
              Expanded(child: _stat('Sisa', '${sold - checkedIn}')),
            ]),
          ),
          // Area kamera (simulasi)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    CustomPaint(
                        size: const Size(260, 260), painter: _CornerPainter()),
                    AnimatedBuilder(
                      animation: line,
                      builder: (_, __) => Positioned(
                        left: 14,
                        right: 14,
                        top: 14 + (232 * line.value),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: C.success,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                  color: C.success.withAlpha(150),
                                  blurRadius: 10)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 18),
                const Text('Pratinjau pemindai QR',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                const Text('Gunakan kode manual atau hasil simulasi di bawah.',
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
              ]),
            ),
          ),
          // Tombol kamera
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _round(flash ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                'Senter', () => setState(() => flash = !flash),
                active: flash),
            const SizedBox(width: 24),
            _round(Icons.keyboard_alt_outlined, 'Input Manual', manualInput),
            const SizedBox(width: 24),
            _round(Icons.cameraswitch_outlined, 'Ganti',
                () => toast(context, 'Kamera belum aktif pada pratinjau ini')),
          ]),
          const SizedBox(height: 16),
          // Tombol simulasi hasil scan
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Simulasi hasil scan (demo)',
                  style: TextStyle(
                      fontSize: 12,
                      color: C.textSecondary,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _sim('Valid', C.success, 'valid')),
                const SizedBox(width: 8),
                Expanded(child: _sim('Dipakai', C.error, 'used')),
                const SizedBox(width: 8),
                Expanded(child: _sim('Salah Tgl', C.warning, 'date')),
              ]),
            ]),
          ),
        ])),
      ),
    );
  }

  Widget _stat(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ]),
      );

  Widget _round(IconData icon, String label, VoidCallback onTap,
          {bool active = false}) =>
      Column(children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: active ? C.accent : Colors.white.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: active ? C.text : Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ]);

  Widget _sim(String label, Color color, String type) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => showResult(type),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = C.success
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const l = 40.0;
    final w = size.width, h = size.height;
    canvas.drawPath(
        Path()
          ..moveTo(0, l)
          ..lineTo(0, 0)
          ..lineTo(l, 0),
        p);
    canvas.drawPath(
        Path()
          ..moveTo(w - l, 0)
          ..lineTo(w, 0)
          ..lineTo(w, l),
        p);
    canvas.drawPath(
        Path()
          ..moveTo(0, h - l)
          ..lineTo(0, h)
          ..lineTo(l, h),
        p);
    canvas.drawPath(
        Path()
          ..moveTo(w - l, h)
          ..lineTo(w, h)
          ..lineTo(w, h - l),
        p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
