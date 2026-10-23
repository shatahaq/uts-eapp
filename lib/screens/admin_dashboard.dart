import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _PeriodData {
  final String visitors, tickets, revenue, wait, chartTitle;
  final List<double> values;
  final List<String> labels;
  const _PeriodData(this.visitors, this.tickets, this.revenue, this.wait,
      this.chartTitle, this.values, this.labels);
}

class _AdminDashboardState extends State<AdminDashboard> {
  int period = 1;

  static const data = [
    _PeriodData(
        '342',
        '128',
        'Rp9,8 jt',
        '12 mnt',
        'Kunjungan per jam',
        [10, 25, 40, 60, 45, 70, 50, 30],
        ['08', '09', '10', '11', '12', '13', '14', '15']),
    _PeriodData(
        '2.140',
        '812',
        'Rp61,2 jt',
        '14 mnt',
        'Kunjungan 7 hari terakhir',
        [280, 310, 295, 340, 420, 610, 485],
        ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']),
    _PeriodData('9.320', '3.540', 'Rp268 jt', '13 mnt', 'Kunjungan per minggu',
        [2100, 2350, 2480, 2390], ['M1', 'M2', 'M3', 'M4']),
  ];

  static const perDest = [
    ('Istana Maimun', 0.45, C.accent),
    ('Museum Sumut', 0.25, C.primary),
    ('Tour Danau Toba', 0.20, C.info),
    ('Tjong A Fie', 0.10, Color(0xFFB5532F)),
  ];

  static const trx = [
    ('MST-240315-4821', 'Budi Santoso', 'Istana Maimun', 'Rp47.000'),
    ('MST-240315-3377', 'Siti Rahma', 'Tour Danau Toba', 'Rp702.000'),
    ('MST-240315-1209', 'Andi Pratama', 'Museum Sumut', 'Rp15.000'),
    ('MST-240315-9954', 'Lina Wong', 'Tjong A Fie', 'Rp92.000'),
  ];

  @override
  Widget build(BuildContext context) {
    final d = data[period];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: 'Salin ringkasan',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(
                  text: 'Medan Smart Tourism — data contoh\n${[
                'Hari ini',
                'Minggu ini',
                'Bulan ini'
              ][period]}\nPengunjung: ${d.visitors}\nTiket: ${d.tickets}\nPendapatan: ${d.revenue}\nWaktu tunggu: ${d.wait}'));
              if (context.mounted) toast(context, 'Ringkasan disalin');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (r) => false),
          ),
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text('Ringkasan operasional',
                style: editorial.copyWith(fontSize: 30)),
            const SizedBox(height: 8),
            const Text('Data contoh · Medan Smart Tourism',
                style: TextStyle(fontSize: 11, color: C.textSecondary)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 0, label: Text('Hari Ini')),
                  ButtonSegment(value: 1, label: Text('Minggu Ini')),
                  ButtonSegment(value: 2, label: Text('Bulan Ini')),
                ],
                selected: {period},
                onSelectionChanged: (s) => setState(() => period = s.first),
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                  child: _kpi('Total Pengunjung', d.visitors,
                      Icons.groups_rounded, C.primary, '+12%')),
              const SizedBox(width: 12),
              Expanded(
                  child: _kpi('Tiket Terjual', d.tickets,
                      Icons.confirmation_number_rounded, C.accent, '+8%')),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _kpi('Pendapatan', d.revenue, Icons.payments_rounded,
                      C.success, '+15%')),
              const SizedBox(width: 12),
              Expanded(
                  child: _kpi('Rata-rata Tunggu', d.wait, Icons.timer_rounded,
                      C.warning, '-2 mnt')),
            ]),
            const SizedBox(height: 18),
            SoftCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.chartTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 190,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _LinePainter(d.values, d.labels),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 18),
            SoftCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pengunjung per Destinasi',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 14),
                    for (final p in perDest)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(children: [
                          Row(children: [
                            Expanded(
                                child: Text(p.$1,
                                    style: const TextStyle(fontSize: 13))),
                            Text('${(p.$2 * 100).round()}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: p.$2,
                              minHeight: 8,
                              backgroundColor: C.divider,
                              valueColor: AlwaysStoppedAnimation(p.$3),
                            ),
                          ),
                        ]),
                      ),
                  ]),
            ),
            const SizedBox(height: 18),
            const Text('Transaksi Terbaru',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            const SizedBox(height: 10),
            SoftCard(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Column(children: [
                for (int i = 0; i < trx.length; i++) ...[
                  ListTile(
                    dense: true,
                    leading: const CircleAvatar(
                        backgroundColor: C.primaryLight,
                        child: Icon(Icons.receipt_long_rounded,
                            color: C.primary, size: 20)),
                    title: Text(trx[i].$2,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${trx[i].$3} • ${trx[i].$1}',
                        style: const TextStyle(fontSize: 11)),
                    trailing: Text(trx[i].$4,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: C.primary)),
                  ),
                  if (i < trx.length - 1) const Divider(height: 1),
                ]
              ]),
            ),
          ]),
    );
  }

  Widget _kpi(String label, String value, IconData icon, Color color,
          String change) =>
      SoftCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: color.withAlpha(35),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(change,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            change.startsWith('-') ? C.warning : C.success))),
          ]),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: C.textSecondary)),
        ]),
      );
}

class _LinePainter extends CustomPainter {
  final List<double> v;
  final List<String> labels;
  _LinePainter(this.v, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    const bottom = 24.0;
    const top = 10.0;
    final h = size.height - bottom - top;
    final w = size.width;
    double maxV = v.first;
    for (final x in v) {
      if (x > maxV) maxV = x;
    }
    maxV *= 1.15;

    final grid = Paint()
      ..color = C.divider
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = top + h * i / 3;
      canvas.drawLine(Offset(0, y), Offset(w, y), grid);
    }

    final n = v.length;
    final pts = <Offset>[
      for (int i = 0; i < n; i++)
        Offset(16 + (w - 32) * (n == 1 ? 0 : i / (n - 1)),
            top + h * (1 - v[i] / maxV)),
    ];

    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    final fill = Path.from(line)
      ..lineTo(pts.last.dx, top + h)
      ..lineTo(pts.first.dx, top + h)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [C.primary.withAlpha(90), C.primary.withAlpha(0)],
        ).createShader(Rect.fromLTWH(0, top, w, h)),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = C.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    for (int i = 0; i < n; i++) {
      canvas.drawCircle(pts[i], 5, Paint()..color = Colors.white);
      canvas.drawCircle(
          pts[i],
          5,
          Paint()
            ..color = C.primary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5);
      final tp = TextPainter(
        text: TextSpan(
            text: labels[i],
            style: const TextStyle(fontSize: 11, color: C.textSecondary)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pts[i].dx - tp.width / 2, size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => old.v != v;
}
