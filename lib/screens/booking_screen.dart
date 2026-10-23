import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Destination dest;
  const BookingScreen({super.key, required this.dest});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime date = DateUtils.dateOnly(DateTime.now());
  int? session;
  int adult = 1, child = 0, foreign = 0;
  final promo = TextEditingController();
  bool promoApplied = false;
  String? promoError;
  Destination get d => widget.dest;
  int get people => adult + child + foreign;
  int get subtotal =>
      adult * d.priceAdult + child * d.priceChild + foreign * d.priceForeign;
  int get discount => promoApplied ? min(10000, subtotal) : 0;
  Order get order => Order(
      dest: d,
      date: date,
      session: session == null ? '' : d.sessions[session!],
      adult: adult,
      child: child,
      foreign: foreign,
      discount: discount);
  @override
  void dispose() {
    promo.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final selected = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateUtils.dateOnly(DateTime.now()),
        lastDate: DateTime.now().add(const Duration(days: 60)),
        helpText: 'Tanggal kunjungan',
        cancelText: 'Batal',
        confirmText: 'Pilih');
    if (selected != null) {
      setState(() {
        date = selected;
        session = null;
      });
    }
  }

  void change(int which, int delta) {
    if (delta > 0 && session == null) {
      toast(context, 'Pilih waktu kunjungan terlebih dahulu.');
      return;
    }
    if (delta > 0 && people + delta > d.quota[session!]) {
      toast(
          context, 'Sesi ini tersedia untuk ${d.quota[session!]} pengunjung.');
      return;
    }
    setState(() {
      if (which == 0) adult = max(0, adult + delta);
      if (which == 1) child = max(0, child + delta);
      if (which == 2) foreign = max(0, foreign + delta);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Rencanakan kunjungan')),
        body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const BookingSteps(current: 0),
              const SizedBox(height: 16),
              Row(children: [
                DestCover(dest: d, height: 64, width: 64, radius: 10),
                const SizedBox(width: 13),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(d.category.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.2,
                              color: C.textSecondary)),
                      const SizedBox(height: 6),
                      Text(d.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800)),
                    ])),
              ]),
              const SizedBox(height: 28),
              _heading('Kapan kamu berkunjung?'),
              const SizedBox(height: 6),
              const Text('Pilih tanggal dan waktu yang paling pas.',
                  style: TextStyle(fontSize: 11, color: C.textSecondary)),
              const SizedBox(height: 14),
              SoftCard(
                  onTap: pickDate,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: C.primary, size: 21),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(dateStr(date),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700))),
                    const Text('Ubah',
                        style: TextStyle(
                            fontSize: 11,
                            color: C.primary,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 5),
                    const Icon(Icons.expand_more, size: 18),
                  ])),
              const SizedBox(height: 16),
              LayoutBuilder(
                  builder: (_, constraints) =>
                      Wrap(spacing: 10, runSpacing: 10, children: [
                        for (int i = 0; i < d.sessions.length; i++)
                          _session(i, (constraints.maxWidth - 10) / 2),
                      ])),
              const SizedBox(height: 28),
              _heading('Siapa yang ikut?'),
              const SizedBox(height: 14),
              SoftCard(
                  child: Column(children: [
                _stepper('Dewasa', d.priceAdult, adult, 0),
                const Divider(height: 28),
                _stepper('Anak-anak', d.priceChild, child, 1),
                const Divider(height: 28),
                _stepper('Mancanegara', d.priceForeign, foreign, 2),
              ])),
              if (people == 0)
                const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Tambahkan minimal satu pengunjung.',
                        style: TextStyle(fontSize: 11, color: C.error))),
              const SizedBox(height: 18),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                shape: const Border(),
                collapsedShape: const Border(),
                title: const Text('Punya kode promo?',
                    style: TextStyle(
                        fontSize: 12,
                        color: C.primary,
                        fontWeight: FontWeight.w700)),
                leading: const Icon(Icons.local_offer_outlined,
                    size: 19, color: C.primary),
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        child: TextField(
                            controller: promo,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                                hintText: 'Kode promo', errorText: promoError),
                            onChanged: (_) => setState(() {
                                  promoApplied = false;
                                  promoError = null;
                                }))),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 86,
                        child: PrimaryButton(
                            label: 'Pakai',
                            onTap: () => setState(() {
                                  promoApplied =
                                      promo.text.trim().toUpperCase() ==
                                          'MEDAN10';
                                  promoError = promoApplied
                                      ? null
                                      : 'Kode tidak dikenali';
                                }))),
                  ]),
                  const SizedBox(height: 10),
                ],
              ),
              if (promoApplied)
                const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('MEDAN10 diterapkan. Hemat hingga Rp10.000.',
                        style: TextStyle(fontSize: 11, color: C.success))),
              const Divider(height: 24),
              InfoRow('Tiket ($people pengunjung)', rp(subtotal)),
              InfoRow('Biaya layanan', rp(order.fee)),
              if (discount > 0) InfoRow('Potongan promo', '-${rp(discount)}'),
              const SizedBox(height: 10),
              const Text(
                  'Harga sudah termasuk biaya layanan. Periksa jadwal sebelum melanjutkan.',
                  style: TextStyle(
                      fontSize: 10, height: 1.6, color: C.textSecondary)),
            ]),
        bottomNavigationBar: BottomAction(
            caption: 'Total · $people tiket',
            value: rp(order.total),
            label: 'Lanjut bayar',
            onTap: session != null && people > 0 && people <= d.quota[session!]
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentScreen(order: order)))
                : null),
      );
  Widget _heading(String t) => Text(t,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -.5));
  Widget _session(int i, double width) {
    final full = d.quota[i] == 0, selected = session == i;
    return Semantics(
        selected: selected,
        enabled: !full,
        child: SizedBox(
          width: width,
          child: Material(
            color: full
                ? C.divider.withValues(alpha: .4)
                : selected
                    ? C.primaryLight
                    : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: selected ? C.primary : C.divider)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: full
                  ? null
                  : () => setState(() {
                        session = i;
                        if (people > d.quota[i]) {
                          adult = 1;
                          child = 0;
                          foreign = 0;
                        }
                      }),
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.sessions[i],
                            style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                                color: full ? C.textSecondary : C.text)),
                        const SizedBox(height: 7),
                        Row(children: [
                          Expanded(
                              child: Text(
                                  full
                                      ? 'Tidak tersedia'
                                      : '${d.quota[i]} tiket tersedia',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color:
                                          full ? C.textSecondary : C.primary))),
                          Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 16,
                              color: full ? C.disabled : C.primary),
                        ]),
                      ])),
            ),
          ),
        ));
  }

  Widget _stepper(String label, int price, int value, int which) =>
      Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(rp(price),
              style: const TextStyle(fontSize: 11, color: C.textSecondary)),
        ])),
        IconButton.outlined(
            tooltip: 'Kurangi $label',
            onPressed: value > 0 ? () => change(which, -1) : null,
            style:
                IconButton.styleFrom(side: const BorderSide(color: C.divider)),
            icon: const Icon(Icons.remove, size: 18)),
        SizedBox(
            width: 30,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700))),
        IconButton.outlined(
            tooltip: 'Tambah $label',
            onPressed: session == null || people >= d.quota[session!]
                ? null
                : () => change(which, 1),
            style:
                IconButton.styleFrom(side: const BorderSide(color: C.divider)),
            icon: const Icon(Icons.add, size: 18)),
      ]);
}
