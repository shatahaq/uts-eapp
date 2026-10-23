import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'booking_screen.dart';

class DetailScreen extends StatelessWidget {
  final Destination dest;
  const DetailScreen({super.key, required this.dest});
  @override
  Widget build(BuildContext context) {
    final d = dest;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 320,
          backgroundColor: C.bg,
          leadingWidth: 68,
          leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton.filled(
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white, foregroundColor: C.text),
                  tooltip: 'Kembali',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 21))),
          actions: [SaveButton(dest: d), const SizedBox(width: 16)],
          flexibleSpace: FlexibleSpaceBar(
              background: DestCover(dest: d, height: 350, radius: 0)),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(
                spacing: 14,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Pill(d.category, C.primary),
                  Text.rich(
                      TextSpan(children: [
                        const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(Icons.star_rounded,
                                color: C.accent, size: 18)),
                        TextSpan(
                            text: ' ${d.rating}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                        TextSpan(
                            text: '  (${d.reviews} ulasan)',
                            style: const TextStyle(color: C.textSecondary)),
                      ]),
                      style: const TextStyle(fontSize: 11)),
                ]),
            const SizedBox(height: 16),
            Text(d.name, style: editorial.copyWith(fontSize: 34)),
            const SizedBox(height: 10),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.location_on_outlined,
                  size: 17, color: C.textSecondary),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(d.location,
                      style: const TextStyle(
                          fontSize: 11, color: C.textSecondary, height: 1.6))),
            ]),
            const SizedBox(height: 22),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: C.primaryLight,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.schedule_outlined,
                      size: 22, color: C.primary),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Jam kunjungan',
                            style: TextStyle(
                                fontSize: 10, color: C.textSecondary)),
                        const SizedBox(height: 4),
                        Text('${d.hours} WIB',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ])),
                  Pill(d.crowd, crowdColor(d.crowd),
                      icon: Icons.people_outline_rounded),
                ])),
            const SizedBox(height: 8),
            const Text('Jam, harga, dan kepadatan merupakan data contoh.',
                style: TextStyle(fontSize: 9, color: C.textSecondary)),
            const SizedBox(height: 26),
            _heading('Ada cerita di sini.'),
            const SizedBox(height: 10),
            Text(d.desc,
                style: const TextStyle(
                    fontSize: 12, height: 1.85, color: C.textSecondary)),
            const SizedBox(height: 26),
            _heading('Yang tersedia'),
            const SizedBox(height: 14),
            Wrap(
                spacing: 10,
                runSpacing: 12,
                children: d.facilities
                    .map((f) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: C.divider),
                              borderRadius: BorderRadius.circular(9)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(_facilityIcon(f), size: 17, color: C.primary),
                            const SizedBox(width: 7),
                            Text(f, style: const TextStyle(fontSize: 11))
                          ]),
                        ))
                    .toList()),
            const SizedBox(height: 26),
            _heading('Tiket kunjungan'),
            const SizedBox(height: 12),
            SoftCard(
                child: Column(children: [
              InfoRow('Dewasa', rp(d.priceAdult)),
              const Divider(height: 16),
              InfoRow('Anak-anak', rp(d.priceChild)),
              const Divider(height: 16),
              InfoRow('Mancanegara', rp(d.priceForeign)),
            ])),
            const SizedBox(height: 12),
            const Row(children: [
              Icon(Icons.qr_code_2_rounded, size: 17, color: C.primary),
              SizedBox(width: 8),
              Expanded(
                  child: Text('E-tiket langsung tersedia setelah pembayaran.',
                      style: TextStyle(fontSize: 10, color: C.textSecondary)))
            ]),
            const SizedBox(height: 26),
            _heading('Sebelum berkunjung'),
            const SizedBox(height: 8),
            const Text(
                'Pilih tanggal dan sesi sesuai rencana. Tunjukkan QR e-tiket kepada petugas saat tiba. Nomor antrean dapat diambil pada hari kunjungan.',
                style: TextStyle(
                    fontSize: 12, height: 1.8, color: C.textSecondary)),
            const SizedBox(height: 14),
            OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: d.location));
                  if (context.mounted) toast(context, 'Alamat disalin');
                },
                icon: const Icon(Icons.copy_outlined, size: 16),
                label:
                    const Text('Salin alamat', style: TextStyle(fontSize: 12))),
            const SizedBox(height: 14),
            TextButton(
                onPressed: () => showPhotoCredits(context),
                child:
                    const Text('Kredit foto', style: TextStyle(fontSize: 10))),
          ]),
        )),
      ]),
      bottomNavigationBar: BottomAction(
          caption: 'Mulai / orang',
          value: rp(d.minPrice),
          label: 'Pilih tiket',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => BookingScreen(dest: d)))),
    );
  }

  Widget _heading(String text) => Text(text,
      style: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -.3));
  IconData _facilityIcon(String f) => switch (f) {
        'Parkir' => Icons.local_parking_rounded,
        'Toilet' => Icons.wc_outlined,
        'Mushola' => Icons.mosque_outlined,
        'Kafe' => Icons.local_cafe_outlined,
        'Transportasi' => Icons.directions_bus_outlined,
        'Pemandu' => Icons.support_agent_rounded,
        'Makan siang' => Icons.restaurant_outlined,
        'Tiket kapal' => Icons.directions_boat_outlined,
        _ => Icons.accessible_forward_rounded,
      };
}
