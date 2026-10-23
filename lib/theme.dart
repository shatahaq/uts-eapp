import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class C {
  static const primary = Color(0xFF234E46);
  static const primaryDark = Color(0xFF173D36);
  static const primaryLight = Color(0xFFE8EFEB);
  static const accent = Color(0xFFB77B41);
  static const accentLight = Color(0xFFF5EDDF);
  static const success = Color(0xFF307257);
  static const warning = Color(0xFF946326);
  static const error = Color(0xFFB54D43);
  static const info = Color(0xFF416780);
  static const bg = Color(0xFFFAF9F6);
  static const text = Color(0xFF202D29);
  static const textSecondary = Color(0xFF6C756F);
  static const divider = Color(0xFFE6E8E2);
  static const disabled = Color(0xFFB9C1BA);
}

const editorial = TextStyle(
    fontFamily: 'Editorial', fontSize: 34, height: 1.12, color: C.text);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Jakarta',
    scaffoldBackgroundColor: C.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: C.primary).copyWith(
      primary: C.primary,
      secondary: C.accent,
      surface: C.bg,
      onSurface: C.text,
      outline: C.divider,
      error: C.error,
    ),
  );
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: C.text, displayColor: C.text),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.bg,
      foregroundColor: C.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
          fontFamily: 'Jakarta',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: C.text),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: border(C.divider),
      enabledBorder: border(C.divider),
      focusedBorder: border(C.primary),
      errorBorder: border(C.error),
      hintStyle: const TextStyle(fontSize: 14, color: C.textSecondary),
      prefixIconColor: C.textSecondary,
    ),
    dividerTheme: const DividerThemeData(color: C.divider, thickness: 1),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: C.primaryLight,
      labelTextStyle: const WidgetStatePropertyAll(TextStyle(
          fontFamily: 'Jakarta', fontSize: 11, fontWeight: FontWeight.w600)),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          size: 23,
          color:
              s.contains(WidgetState.selected) ? C.primary : C.textSecondary)),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: C.bg, showDragHandle: true),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(
                fontFamily: 'Jakarta',
                fontWeight: FontWeight.w700,
                fontSize: 13))),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: C.primary),
  );
}
