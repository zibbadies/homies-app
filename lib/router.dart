import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/pages/home.dart';
import 'package:homies/pages/login.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    if (state.matchedLocation == '/') {
      return '/login';
    }
    return null;
  },
);

