import 'package:flutter/material.dart';

final theme = ThemeData(
  fontFamily: 'Poppins',

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFFC342),
    onPrimary: Color(0xFF202020),

    secondary: Color(0xFFE5E5E5),
    onSecondary: Color(0xCC202020),

    surface: Color(0xFFF6F6F6), // app background
    onSurface: Color(0xFF202020),

    surfaceContainer: Color(0xFFFFFFFF), // input field / cards

    error: Color(0xFFB94E4E),
    onError: Color(0xFFFFFFFF),
  ),

  textTheme: TextTheme(
    headlineMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),
);
