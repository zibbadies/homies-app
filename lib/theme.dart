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
    displayLarge: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),

    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),

    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),
);
