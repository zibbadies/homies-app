import 'package:flutter/material.dart';
import 'package:homies/providers/router_provider.dart';
import 'package:homies/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

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
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
