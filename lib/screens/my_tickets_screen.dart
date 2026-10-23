import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'ticket_screen.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
              child:
                  Text('Tiket saya', style: editorial.copyWith(fontSize: 34))),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Semua rencana, dalam satu tempat.',
                  style: TextStyle(fontSize: 12, color: C.textSecondary))),
          const SizedBox(height: 20),
          const TabBar(
              dividerColor: C.divider,
              labelColor: C.primary,
              indicatorColor: C.primary,
              unselectedLabelColor: C.textSecondary,
              labelStyle: TextStyle(
                  fontFamily: 'Jakarta',
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
              tabs: [Tab(text: 'Akan datang'), Tab(text: 'Riwayat')]),
          Expanded(
              child: ListenableBuilder(
                  listenable: appState,
                  builder: (_, __) => TabBarView(children: [
                        _list(context, appState.active, true),
                        _list(context, appState.finished, false),
                      ]))),
        ]),
      ));
  Widget _list(BuildContext context, List<Ticket> items, bool active) {
    if (items.isEmpty) {
      return EmptyState(
          icon: Icons.confirmation_number_outlined,
          title: active ? 'Perjalanan berikutnya?' : 'Belum ada riwayat',
          message: active
              ? 'Tempat baru menunggu untuk kamu temukan.\nPilih destinasi dan rencanakan kunjunganmu.'
              : 'Kunjungan yang sudah selesai akan muncul di sini.',
          buttonText: active ? 'Temukan destinasi' : null,
          onButton: () => tabIndex.value = 0);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (_, i) {
        final t = items[i];
        return SoftCard(
          padding: const EdgeInsets.all(16),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => TicketScreen(ticket: t))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(t.code,
                      style: const TextStyle(
                          fontSize: 9,
                          letterSpacing: .4,
                          color: C.textSecondary))),
              Pill(t.status, t.status == 'Aktif' ? C.success : C.textSecondary)
            ]),
            const SizedBox(height: 16),
            Row(children: [
              DestCover(dest: t.dest, height: 72, width: 72, radius: 10),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(t.dest.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(dateStr(t.date),
                        style: const TextStyle(
                            fontSize: 11, color: C.textSecondary)),
                    Text('${t.people} pengunjung',
                        style: const TextStyle(
                            fontSize: 10, color: C.textSecondary)),
                  ])),
            ]),
            const Divider(height: 28),
            Row(children: [
              const Icon(Icons.schedule_outlined,
                  size: 15, color: C.textSecondary),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(t.session,
                      style: const TextStyle(
                          fontSize: 10, color: C.textSecondary))),
              Text(t.status == 'Aktif' ? 'Buka e-tiket' : 'Lihat detail',
                  style: const TextStyle(
                      fontSize: 11,
                      color: C.primary,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded,
                  color: C.primary, size: 16),
            ]),
          ]),
        );
      },
    );
  }
}
