import 'package:flutter/material.dart';

class AppConfig {
  // Supabase configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // App theme colors - Navy theme
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep navy blue
  static const Color secondaryColor = Color(0xFF3B82F6); // Bright blue
  static const Color accentColor = Color(0xFF60A5FA); // Light blue accent
  static const Color scaffoldBackgroundColor = Color(
    0xFFF8FAFC,
  ); // Very light blue-gray
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF0F172A); // Dark navy
  static const Color secondaryTextColor = Color(0xFF475569); // Medium gray-blue
  static const Color errorColor = Color(0xFFEF4444);
  static const Color surfaceColor = Color(0xFFF1F5F9); // Light surface color

  // Activity categories - Navy themed
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Work', 'color': Color(0xFF1E40AF)}, // Deep blue
    {'name': 'Personal', 'color': Color(0xFF7C3AED)}, // Purple
    {'name': 'Health', 'color': Color(0xFF059669)}, // Emerald
    {'name': 'Shopping', 'color': Color(0xFFDC2626)}, // Red
    {'name': 'Social', 'color': Color(0xFF0891B2)}, // Cyan
    {'name': 'Education', 'color': Color(0xFFCA8A04)}, // Amber
    {'name': 'Other', 'color': Color(0xFF6B7280)}, // Gray
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
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
