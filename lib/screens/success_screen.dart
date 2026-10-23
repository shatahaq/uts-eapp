import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'ticket_screen.dart';

class SuccessScreen extends StatelessWidget {
  final Ticket ticket;
  const SuccessScreen({super.key, required this.ticket});
  @override
  Widget build(BuildContext context) => PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                    color: C.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded,
                    color: C.primary, size: 38)),
            const SizedBox(height: 24),
            Text('Perjalananmu\nsiap dimulai.',
                textAlign: TextAlign.center,
                style: editorial.copyWith(fontSize: 35)),
            const SizedBox(height: 12),
            const Text(
                'E-tiket sudah tersedia di Tiket Saya.\nTunjukkan kode QR saat berkunjung.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, height: 1.8, color: C.textSecondary)),
            const SizedBox(height: 30),
            SoftCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  DestCover(dest: ticket.dest, height: 150, radius: 0),
                  Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(children: [
                        Text(ticket.dest.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        InfoRow('Kunjungan', dateStr(ticket.date)),
                        InfoRow('Sesi', ticket.session),
                        InfoRow('Pengunjung', '${ticket.people} orang'),
                      ])),
                ])),
          ]),
        ))),
        bottomNavigationBar: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  PrimaryButton(
                      label: 'Buka e-tiket',
                      icon: Icons.qr_code_2_rounded,
                      onTap: () {
                        tabIndex.value = 1;
                        final nav = Navigator.of(context);
                        nav.popUntil((r) => r.isFirst);
                        nav.push(MaterialPageRoute(
                            builder: (_) => TicketScreen(ticket: ticket)));
                      }),
                  const SizedBox(height: 8),
                  TextButton(
                      onPressed: () {
                        tabIndex.value = 0;
                        Navigator.popUntil(context, (r) => r.isFirst);
                      },
                      child: const Text('Kembali jelajahi Medan')),
                ]))),
      ));
}
