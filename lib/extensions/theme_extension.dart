import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
}
