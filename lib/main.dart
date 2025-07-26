import 'package:flutter/material.dart';
import 'package:homies/router.dart';
import 'package:homies/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Homies',
      theme: theme,
      routerConfig: router,
    );
  }
}

