import 'package:flutter/material.dart';

class AppColors {
  // Define color shades for different colors
  static final ColorShades primaryColor = ColorShades({
    50: const Color(0xFFDEE5F1),
    100: const Color(0xFFBAC9E2),
    200: const Color(0xFF9CB1DA),
    300: const Color(0xFF88A1CB),
    400: const Color(0xFF6F8EC1),
    500: const Color(0xFF2252A0), // Default
    600: const Color(0xFF1B4280),
    700: const Color(0xFF193B74),
    800: const Color(0xFF143160),
    900: const Color(0xFF0F2548),
  });

  static final ColorShades secondryColor = ColorShades({
    50: const Color(0xFFF8E7F1),
    100: const Color(0xFFE9B6D3),
    200: const Color(0xFFDA94BC),
    300: const Color(0xFFD27FAE),
    400: const Color(0xFFC9659E),
    500: const Color(0xFFAC1269), // Default
    600: const Color(0xFF920F59),
    700: const Color(0xFF7E0DAD),
    800: const Color(0xFF6F0B44),
    900: const Color(0xFF410728),
  });

  static final ColorShades gray = ColorShades({
    50: const Color(0xFFF6FCFC),
    100: const Color(0xFFF6F6F6),
    200: const Color(0xFFF2F2F1),
    300: const Color(0xFFECECEB),
    400: const Color(0xFFD9D9DB),
    500: const Color(0xFFCFCFCD), // Default
    600: const Color(0xFFB5B5B5),
    700: const Color(0xFFA1A1A0),
    800: const Color(0xFF8D8D7C),
    900: const Color(0xFF555F5F),
  });

  static final ColorShades black = ColorShades({
    50: const Color(0xFFEAEAEA),
    100: const Color(0xFFBDBDBC),
    200: const Color(0xFF9D9D9B),
    300: const Color(0xFF70706E),
    400: const Color(0xFF555451),
    500: const Color(0xFF2A2926), // Default
    600: const Color(0xFF262523),
    700: const Color(0xFF1E1D1B),
    800: const Color(0xFF171715),
    900: const Color(0xFF121110),
  });

  static final ColorShades red = ColorShades({
    50: const Color(0xFFFCDCD3),
    100: const Color(0xFFBE123C),
    200: const Color(0xFF4C0519),
  });

  static final ColorShades green = ColorShades({
    50: const Color(0xFFBBF7D0),
    100: const Color(0xFF059669),
    200: const Color(0xFF064E3B),
  });
}

// Base class for shades
class ColorShades {
  final Map<int, Color> _shades;

  ColorShades(this._shades);

  // Default to shade 500 if no shade is specified
  Color get defaultShade => _shades[500] ?? _shades[100]!;

  // Define getters for specific shades
  Color operator [](int shade) => _shades[shade] ?? _shades[500]!;
}
