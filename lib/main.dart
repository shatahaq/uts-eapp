import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

void main() => runApp(const MedanSmartTourismApp());

class MedanSmartTourismApp extends StatelessWidget {
  const MedanSmartTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medan Smart Tourism',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('id'),
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFECEEE9),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600), child: child),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
