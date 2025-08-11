import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/pages/home/home_page.dart';
import 'package:homies/pages/login/login_page.dart';
import 'package:homies/pages/register/register_page.dart';
import 'package:homies/pages/welcome_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    if (state.matchedLocation == '/') {
      return '/welcome';
    }
    return null;
  },
);

