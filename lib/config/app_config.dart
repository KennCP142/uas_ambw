import 'package:flutter/material.dart';

class AppConfig {
  // Supabase configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // App theme colors
  static const Color primaryColor = Color(0xFF4A6572);
  static const Color accentColor = Color(0xFFF9AA33);
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF232F34);
  static const Color secondaryTextColor = Color(0xFF4A6572);
  static const Color errorColor = Color(0xFFE53935);

  // Activity categories
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Work', 'color': Color(0xFF5D9CEC)},
    {'name': 'Personal', 'color': Color(0xFFFFCE54)},
    {'name': 'Health', 'color': Color(0xFFAC92EC)},
    {'name': 'Shopping', 'color': Color(0xFFED5565)},
    {'name': 'Social', 'color': Color(0xFF48CFAD)},
    {'name': 'Education', 'color': Color(0xFFFC6E51)},
    {'name': 'Other', 'color': Color(0xFFBABABA)},
  ];

  // Get color for category
  static Color getCategoryColor(String category) {
    final categoryMap = categories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => {'name': 'Other', 'color': const Color(0xFFBABABA)},
    );
    return categoryMap['color'];
  }

  // App theme
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: secondaryTextColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
