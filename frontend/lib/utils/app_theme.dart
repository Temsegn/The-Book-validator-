import 'package:flutter/material.dart';

class AppTheme {
  // Orthodox colors
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBlue = Color(0xFF1B365D);
  static const Color lightBlue = Color(0xFF4A90E2);
  static const Color burgundy = Color(0xFF8B0000);
  static const Color cream = Color(0xFFFFFDD0);
  static const Color darkGold = Color(0xFFB8860B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGold,
      brightness: Brightness.light,
      primary: primaryGold,
      secondary: darkBlue,
      surface: Colors.white,
      background: cream,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Serif',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: darkBlue,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
    ),
    fontFamily: 'Roboto',
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGold,
      brightness: Brightness.dark,
      primary: primaryGold,
      secondary: lightBlue,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: primaryGold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryGold,
        fontFamily: 'Serif',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: Color(0xFF1E1E1E),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF2D2D2D),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 8,
    ),
    fontFamily: 'Roboto',
  );
}
