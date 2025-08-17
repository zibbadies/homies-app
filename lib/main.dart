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
      scrollBehavior: AppScrollBehavior(),
      theme: theme,
      routerConfig: router,
    );
  }
}


class AppScrollBehavior extends ScrollBehavior {
  // Use bouncing physics on all platforms, better matches the design of the app
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const BouncingScrollPhysics();
}
