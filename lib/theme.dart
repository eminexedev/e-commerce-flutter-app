import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryLight = Color(0xFF64B5F6);

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(seedColor: primary);

    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF9F5F8),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      // Use default CardTheme derived from colorScheme to avoid SDK type mismatches.
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
