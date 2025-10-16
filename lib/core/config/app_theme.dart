import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Primary color seed for the app's palette
  static const Color _primaryColorSeed = Color(0xFF0066FF);

  // Card styling consistent across the app
  static final _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
    ),
    clipBehavior: Clip.antiAlias,
  );

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorSeed,
        brightness: Brightness.light,
      ),
      cardTheme: _cardTheme,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorSeed,
        brightness: Brightness.dark,
      ),
      cardTheme: _cardTheme,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    );
  }

  /// AMOLED Theme Configuration (A true black theme for OLED screens)
  static ThemeData get amoledTheme {
    final darkScheme = ColorScheme.fromSeed(
      seedColor: _primaryColorSeed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black, // True black background
      colorScheme: darkScheme.copyWith(surface: Colors.black),
      cardTheme: _cardTheme.copyWith(
        color: const Color(0xFF121212), // Slightly off-black cards
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
    );
  }
}
