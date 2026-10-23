import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'data.dart';

String rp(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp$b';
}

String dateStr(DateTime d) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];
  return '${d.day} ${m[d.month - 1]} ${d.year}';
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
void toast(BuildContext context, String msg, {Color? color}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color ?? C.text,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
}

Color crowdColor(String level) =>
    switch (level) { 'Sepi' => C.success, 'Ramai' => C.warning, _ => C.error };

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final IconData? icon;
  final Color? color, textColor;
  const PrimaryButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.loading = false,
      this.icon,
      this.color,
      this.textColor});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: color ?? C.primary,
              foregroundColor: textColor ?? Colors.white,
              disabledBackgroundColor: C.divider,
              disabledForegroundColor: C.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: loading ? null : onTap,
          child: loading
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (icon != null) ...[
                    Icon(icon, size: 19),
                    const SizedBox(width: 8)
                  ],
                  Flexible(
                      child: Text(label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700))),
                ]),
        ),
      );
}

class OutlineBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  const OutlineBtn(
      {super.key,
      required this.label,
      required this.onTap,
      this.icon,
      this.color});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                foregroundColor: color ?? C.primary,
                side: BorderSide(color: color ?? C.divider),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: onTap,
            icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 19),
            label: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13))),
      );
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const Pill(this.text, this.color, {super.key, this.icon});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5)
          ],
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
      );
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color color;
  const SoftCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.onTap,
      this.color = Colors.white});
  @override
  Widget build(BuildContext context) => Material(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: C.divider)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap, child: Padding(padding: padding, child: child)),
      );
}

class DestCover extends StatelessWidget {
  final Destination dest;
  final double height, radius, iconSize;
  final double? width;
  const DestCover(
      {super.key,
      required this.dest,
      required this.height,
      this.width,
      this.radius = 14,
      this.iconSize = 56});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(dest.image,
            height: height,
            width: width ?? double.infinity,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            semanticLabel: 'Foto ${dest.name}',
            errorBuilder: (_, __, ___) => Container(
                height: height,
                width: width,
                color: C.primaryLight,
                child: Icon(dest.icon, color: C.primary, size: iconSize))),
      );
}

class SaveButton extends StatelessWidget {
  final Destination dest;
  const SaveButton({super.key, required this.dest});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: appState,
      builder: (_, __) {
        final saved = appState.favorites.contains(dest.id);
        return IconButton.filled(
            style: IconButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: C.primary),
            tooltip: saved ? 'Hapus dari tersimpan' : 'Simpan destinasi',
            onPressed: () => appState.toggleFavorite(dest.id),
            icon: Icon(
                saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                size: 21));
      });
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle(this.title, {super.key, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 18, 14),
        child: Row(children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.5))),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ]),
      );
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final String? buttonText;
  final VoidCallback? onButton;
  const EmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.message,
      this.buttonText,
      this.onButton});
  @override
  Widget build(BuildContext context) => Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: C.primaryLight,
                  borderRadius: BorderRadius.circular(24)),
              child: Icon(icon, size: 34, color: C.primary)),
          const SizedBox(height: 24),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: C.textSecondary, height: 1.6, fontSize: 13)),
          if (buttonText != null) ...[
            const SizedBox(height: 24),
            SizedBox(
                width: 240,
                child: PrimaryButton(label: buttonText!, onTap: onButton))
          ],
        ]),
      ));
}

class InfoRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const InfoRow(this.label, this.value, {super.key, this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Text(label,
                  style:
                      const TextStyle(color: C.textSecondary, fontSize: 13))),
          const SizedBox(width: 12),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                      fontSize: bold ? 18 : 13))),
        ]),
      );
}

class BookingSteps extends StatelessWidget {
  final int current;
  const BookingSteps({super.key, required this.current});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          for (int i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                      height: 3,
                      decoration: BoxDecoration(
                          color: i <= current ? C.primary : C.divider,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 8),
                  Text('${i + 1}. ${['Kunjungan', 'Pembayaran', 'E-tiket'][i]}',
                      style: TextStyle(
                          fontSize: 10,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: i <= current ? C.primary : C.textSecondary)),
                ])),
          ]
        ]),
      );
}

class BottomAction extends StatelessWidget {
  final String caption, value, label;
  final VoidCallback? onTap;
  final bool loading;
  const BottomAction(
      {super.key,
      required this.caption,
      required this.value,
      required this.label,
      required this.onTap,
      this.loading = false});
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: C.divider))),
        child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
              child: Row(children: [
                Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(caption,
                          style: const TextStyle(
                              fontSize: 11, color: C.textSecondary)),
                      const SizedBox(height: 4),
                      Text(value,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: C.primary)),
                    ])),
                const SizedBox(width: 16),
                Expanded(
                    child: PrimaryButton(
                        label: label, onTap: onTap, loading: loading))
              ]),
            )),
      );
}

void showInfo(BuildContext context, String title, String text) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => SafeArea(
              child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  SelectableText(text,
                      style:
                          const TextStyle(height: 1.7, color: C.textSecondary)),
                ]),
          )));
}

Future<void> showPhotoCredits(BuildContext context) async {
  final raw = await rootBundle.loadString('assets/images/credits.json');
  final items = jsonDecode(raw) as List;
  if (!context.mounted) return;
  showInfo(context, 'Kredit foto & font',
      '${items.map((p) => '${p['asset']} — ${p['author']}\n${p['license']} · ${p['licenseUrl']}\n${p['source']}\nFoto ditampilkan dengan pemotongan sesuai layar.').join('\n\n')}\n\nFont: Plus Jakarta Sans dan DM Serif Display, dari Google Fonts. Lisensi SIL Open Font License 1.1 tersedia dalam folder assets/fonts.');
}
