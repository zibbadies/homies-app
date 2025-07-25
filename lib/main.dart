import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/pages/login.dart';

void main() {
  runApp(const MyApp());
}


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Placeholder(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}

