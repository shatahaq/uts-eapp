import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Order order;
  const PaymentScreen({super.key, required this.order});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selected = 0;
  bool agree = false, paying = false;
  static const methods = [
    ('QRIS', 'E-wallet & mobile banking', Icons.qr_code_2_rounded),
    ('BCA Virtual Account', 'Transfer bank', Icons.account_balance_outlined),
    (
      'Mandiri Virtual Account',
      'Transfer bank',
      Icons.account_balance_outlined
    ),
    ('GoPay', 'Dompet digital', Icons.account_balance_wallet_outlined),
    ('DANA', 'Dompet digital', Icons.account_balance_wallet_outlined),
    ('OVO', 'Dompet digital', Icons.account_balance_wallet_outlined),
  ];
  Future<void> pay() async {
    if (!agree || paying) return;
    setState(() => paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final ticket = appState.createTicket(widget.order);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => SuccessScreen(ticket: ticket)));
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return PopScope(
        canPop: !paying,
        child: Scaffold(
          appBar: AppBar(title: const Text('Pembayaran')),
          body: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                const BookingSteps(current: 1),
                const SizedBox(height: 20),
                Text('Satu langkah lagi.',
                    style: editorial.copyWith(fontSize: 30)),
                const SizedBox(height: 8),
                const Text('Periksa rencanamu sebelum menyelesaikan pesanan.',
                    style: TextStyle(
                        fontSize: 11, height: 1.6, color: C.textSecondary)),
                const SizedBox(height: 20),
                SoftCard(
                    child: Column(children: [
                  Row(children: [
                    DestCover(dest: o.dest, height: 62, width: 62, radius: 10),
                    const SizedBox(width: 13),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(o.dest.name,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text(dateStr(o.date),
                              style: const TextStyle(
                                  fontSize: 11, color: C.textSecondary)),
                          Text('${o.session} WIB',
                              style: const TextStyle(
                                  fontSize: 10, color: C.textSecondary)),
                        ])),
                  ]),
                  const Divider(height: 30),
                  if (o.adult > 0)
                    InfoRow(
                        'Dewasa × ${o.adult}', rp(o.adult * o.dest.priceAdult)),
                  if (o.child > 0)
                    InfoRow('Anak-anak × ${o.child}',
                        rp(o.child * o.dest.priceChild)),
                  if (o.foreign > 0)
                    InfoRow('Mancanegara × ${o.foreign}',
                        rp(o.foreign * o.dest.priceForeign)),
                  InfoRow('Biaya layanan', rp(o.fee)),
                  if (o.discount > 0)
                    InfoRow('Potongan promo', '-${rp(o.discount)}'),
                  const Divider(height: 24),
                  InfoRow('Total pembayaran', rp(o.total), bold: true),
                ])),
                const SizedBox(height: 28),
                const Text('Pilih cara bayar',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (int i = 0; i < methods.length; i++)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Semantics(
                        selected: selected == i,
                        child: SoftCard(
                            color:
                                selected == i ? C.primaryLight : Colors.white,
                            padding: const EdgeInsets.all(14),
                            onTap: paying
                                ? null
                                : () => setState(() => selected = i),
                            child: Row(children: [
                              Icon(methods[i].$3, color: C.primary, size: 25),
                              const SizedBox(width: 13),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(methods[i].$1,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(methods[i].$2,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: C.textSecondary)),
                                  ])),
                              Icon(
                                  selected == i
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  size: 20,
                                  color:
                                      selected == i ? C.primary : C.disabled),
                            ])),
                      )),
                const SizedBox(height: 10),
                CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: agree,
                    onChanged: paying
                        ? null
                        : (v) => setState(() => agree = v ?? false),
                    title: const Text(
                        'Saya sudah memeriksa tanggal, sesi, dan jumlah pengunjung.',
                        style: TextStyle(fontSize: 11, height: 1.6))),
                const SizedBox(height: 12),
                Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: C.accentLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: C.warning, size: 17),
                          SizedBox(width: 9),
                          Expanded(
                              child: Text(
                                  'Pembayaran simulasi. Tidak ada saldo yang dipotong atau uang yang ditagihkan.',
                                  style: TextStyle(
                                      fontSize: 10,
                                      height: 1.7,
                                      color: C.warning))),
                        ])),
              ]),
          bottomNavigationBar: BottomAction(
              caption: 'Total pembayaran',
              value: rp(o.total),
              label: 'Konfirmasi',
              loading: paying,
              onTap: agree && !paying ? pay : null),
        ));
  }
}
