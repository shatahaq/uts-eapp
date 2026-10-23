import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';

class TicketScreen extends StatelessWidget {
  final Ticket ticket;
  const TicketScreen({super.key, required this.ticket});

  Color get statusColor {
    switch (ticket.status) {
      case 'Aktif':
        return C.success;
      case 'Dibatalkan':
        return C.error;
      default:
        return C.textSecondary;
    }
  }

  Future<void> takeQueue(BuildContext context) async {
    final t = ticket;
    if (!isSameDay(t.date, DateTime.now())) {
      toast(context, 'Nomor antrean tersedia pada ${dateStr(t.date)}',
          color: C.warning);
      return;
    }
    final nav = Navigator.of(context);
    if (t.queueNo != null) {
      tabIndex.value = 2;
      nav.popUntil((r) => r.isFirst);
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Ambil nomor antrean?'),
        content: Text('Kamu akan masuk antrean ${t.dest.name}.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: C.primary),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Ambil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    appState.takeQueue(t);
    tabIndex.value = 2;
    nav.popUntil((r) => r.isFirst);
  }

  Future<void> cancel(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan tiket?'),
        content: const Text(
            'Tiket demo akan dinonaktifkan. Tidak ada transaksi uang atau pengembalian dana nyata.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Kembali')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Batalkan Tiket',
                  style: TextStyle(color: C.error))),
        ],
      ),
    );
    if (ok != true) return;
    ticket.status = 'Dibatalkan';
    ticket.queueNo = null;
    appState.tick();
    if (context.mounted) {
      toast(context, 'Tiket dibatalkan');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final t = ticket;
        final active = t.status == 'Aktif';
        return Scaffold(
          appBar: AppBar(title: const Text('E-tiket kunjungan')),
          body: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                Center(child: Pill(t.status, statusColor, icon: Icons.circle)),
                const SizedBox(height: 16),
                // ===== Kartu tiket bergaya perforasi =====
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: C.divider),
                  ),
                  child: Column(children: [
                    // Bagian atas
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              DestCover(
                                  dest: t.dest,
                                  height: 56,
                                  width: 56,
                                  radius: 16,
                                  iconSize: 26),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(t.dest.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ]),
                            const SizedBox(height: 16),
                            Row(children: [
                              Expanded(
                                  child: _field('Tanggal', dateStr(t.date))),
                              Expanded(child: _field('Sesi', t.session)),
                            ]),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                  child: _field('Pengunjung', t.peopleText)),
                              Expanded(child: _field('Pemesan', t.buyer)),
                            ]),
                          ]),
                    ),
                    // Garis perforasi
                    SizedBox(
                      height: 24,
                      child: Stack(clipBehavior: Clip.none, children: [
                        Center(
                          child: LayoutBuilder(builder: (context, c) {
                            final n = ((c.maxWidth - 48) / 12).floor();
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    n,
                                    (_) => Container(
                                        width: 6, height: 2, color: C.divider)),
                              ),
                            );
                          }),
                        ),
                        const Positioned(
                            left: -12,
                            top: 0,
                            child: CircleAvatar(
                                radius: 12, backgroundColor: C.bg)),
                        const Positioned(
                            right: -12,
                            top: 0,
                            child: CircleAvatar(
                                radius: 12, backgroundColor: C.bg)),
                      ]),
                    ),
                    // Bagian bawah: QR
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(children: [
                        Stack(alignment: Alignment.center, children: [
                          Opacity(
                            opacity: active ? 1 : 0.15,
                            child: QrImageView(
                              data: t.code,
                              size: 220,
                              eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square, color: C.text),
                              dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: C.text),
                            ),
                          ),
                          if (!active)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(t.status.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                        ]),
                        const SizedBox(height: 8),
                        Text(
                            active
                                ? 'Tunjukkan ke petugas'
                                : 'QR tidak berlaku',
                            style: const TextStyle(color: C.textSecondary)),
                        const SizedBox(height: 4),
                        Text(t.code,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                fontSize: 16)),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                if (active) ...[
                  PrimaryButton(
                    label: t.queueNo == null
                        ? 'Ambil nomor antrean'
                        : 'Lihat antrean (${t.queueLabel})',
                    icon: Icons.groups_rounded,
                    color: C.primary,
                    textColor: Colors.white,
                    onTap: () => takeQueue(context),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(children: [
                  Expanded(
                    child: OutlineBtn(
                        label: 'Salin kode',
                        icon: Icons.copy_outlined,
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: t.code));
                          if (context.mounted) {
                            toast(context, 'Kode tiket disalin');
                          }
                        }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlineBtn(
                        label: 'Alamat',
                        icon: Icons.location_on_outlined,
                        onTap: () =>
                            showInfo(context, t.dest.name, t.dest.location)),
                  ),
                ]),
                if (active) ...[
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                      onPressed: () => cancel(context),
                      child: const Text('Batalkan Tiket',
                          style: TextStyle(color: C.error)),
                    ),
                  ]),
                ],
              ]),
        );
      },
    );
  }

  Widget _field(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: C.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      );
}
