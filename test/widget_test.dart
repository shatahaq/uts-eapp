import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medan_smart_tourism/data.dart';
import 'package:medan_smart_tourism/main.dart';
import 'package:medan_smart_tourism/screens/booking_screen.dart';
import 'package:medan_smart_tourism/screens/detail_screen.dart';
import 'package:medan_smart_tourism/screens/payment_screen.dart';
import 'package:medan_smart_tourism/screens/success_screen.dart';
import 'package:medan_smart_tourism/screens/ticket_screen.dart';
import 'package:medan_smart_tourism/screens/main_shell.dart';
import 'package:medan_smart_tourism/screens/staff_screen.dart';
import 'package:medan_smart_tourism/screens/admin_dashboard.dart';
import 'package:medan_smart_tourism/theme.dart';

void phone(WidgetTester tester, {double width = 390}) {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  appState.favorites.clear();
  appState.tickets.removeWhere((t) => t.status == 'Aktif');
  tabIndex.value = 0;
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 250,
      scrollable: find.byType(Scrollable).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Main tabs and photo credits work on a narrow screen',
      (tester) async {
    phone(tester, width: 320);
    await tester
        .pumpWidget(MaterialApp(theme: buildTheme(), home: const MainShell()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tiket Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Perjalanan berikutnya?'), findsOneWidget);
    await tester.tap(find.text('Antrean'));
    await tester.pumpAndSettle();
    expect(find.text('Belum masuk antrean'), findsOneWidget);
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Kredit foto & font'));
    await tester.tap(find.text('Kredit foto & font'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mimihitam'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Staff and admin remain usable on a narrow screen',
      (tester) async {
    phone(tester, width: 320);
    await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const StaffScreen()));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.scrollUntilVisible(find.text('Valid'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Valid'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Tiket Valid'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
        MaterialApp(theme: buildTheme(), home: const AdminDashboard()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hari Ini'));
    await tester.pumpAndSettle();
    expect(find.text('342'), findsOneWidget);
  });

  testWidgets('Login validates locally and guest search filters every result',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(const MedanSmartTourismApp());
    await reveal(tester, find.text('Masuk').first);
    await tester.tap(find.text('Masuk').first);
    await tester.pumpAndSettle();
    expect(find.text('Isi email atau nomor HP.'), findsOneWidget);
    expect(find.text('Gunakan minimal 4 karakter.'), findsOneWidget);
    await reveal(tester, find.text('Jelajahi tanpa masuk'));
    await tester.tap(find.text('Jelajahi tanpa masuk'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Tjong');
    await tester.pumpAndSettle();
    expect(find.text('1 tempat ditemukan'), findsOneWidget);
    expect(find.text('Istana Maimun'), findsNothing);
    expect(find.text('Tjong A Fie Mansion'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'Visit flow keeps fees and promo consistent through the QR ticket',
      (tester) async {
    phone(tester);
    appState.identify('Ayu', 'ayu@example.com');
    await tester.pumpWidget(MaterialApp(
        theme: buildTheme(), home: BookingScreen(dest: destinations.first)));
    await tester.pumpAndSettle();
    expect(find.text('Rp12.000'), findsOneWidget);
    final full = find.text('13.00 - 15.00');
    await tester.tap(full);
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Lanjut bayar'))
            .onPressed,
        isNull);
    await tester.tap(find.text('08.00 - 10.00'));
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Punya kode promo?'));
    await tester.tap(find.text('Punya kode promo?'));
    await tester.pumpAndSettle();
    await reveal(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'MEDAN10');
    await tester.tap(find.text('Pakai'));
    await tester.pumpAndSettle();
    expect(find.text('Rp2.000'), findsWidgets);
    await tester.tap(find.text('Lanjut bayar'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentScreen), findsOneWidget);
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Konfirmasi'))
            .onPressed,
        isNull);
    await reveal(tester, find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.byType(SuccessScreen), findsOneWidget);
    expect(appState.active.single.total, 2000);
    expect(appState.active.single.buyer, 'Ayu');
    await tester.tap(find.text('Buka e-tiket'));
    await tester.pumpAndSettle();
    expect(find.byType(TicketScreen), findsOneWidget);
    expect(find.text(appState.active.single.code), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Saved destinations and booking fit a small phone with larger text',
      (tester) async {
    phone(tester, width: 320);
    await tester.pumpWidget(MaterialApp(
        theme: buildTheme(),
        builder: (_, child) => MediaQuery(
            data: const MediaQueryData(
                size: Size(320, 844), textScaler: TextScaler.linear(1.3)),
            child: child!),
        home: DetailScreen(dest: destinations.first)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Simpan destinasi'));
    await tester.pumpAndSettle();
    expect(appState.favorites, contains('maimun'));
    await tester.tap(find.text('Pilih tiket'));
    await tester.pumpAndSettle();
    expect(find.byType(BookingScreen), findsOneWidget);
    await reveal(tester, find.text('Punya kode promo?'));
  });
}
