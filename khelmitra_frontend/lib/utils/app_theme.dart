import 'package:flutter/material.dart';

class AppTheme {
  // App colors
  static const Color primaryColor = Color(0xFF1E88E5);  // Blue
  static const Color accentColor = Color(0xFFFF9800);   // Orange
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: textColor),
      displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
      displaySmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: textColor),
      bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: textColor),
      bodySmall: TextStyle(fontSize: 12.0, color: secondaryTextColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primaryColor),
        side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: primaryColor)),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primaryColor),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 4, horizontal: 8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor)),
      hintStyle: const TextStyle(color: secondaryTextColor),
      errorStyle: const TextStyle(color: errorColor),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
  
  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      background: Color(0xFF121212),
      error: errorColor,
      surface: Color(0xFF1E1E1E),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12.0, color: Colors.white70),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primaryColor),
        side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: primaryColor)),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(primaryColor),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 4, horizontal: 8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: errorColor)),
      hintStyle: const TextStyle(color: Colors.white54),
      errorStyle: const TextStyle(color: errorColor),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}