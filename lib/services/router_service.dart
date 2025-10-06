import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:homies/data/models/home.dart';
import 'package:homies/ui/components/auth_guard.dart';
import 'package:homies/ui/pages/create_home/create_home.dart';
import 'package:homies/ui/pages/create_home/invite_after_create_home.dart';
import 'package:homies/ui/pages/home/home_page.dart';
import 'package:homies/ui/pages/join_home/join_confirm.dart';
import 'package:homies/ui/pages/join_home/join_home.dart';
import 'package:homies/ui/pages/login/login_page.dart';
import 'package:homies/ui/pages/register/register_page.dart';
import 'package:homies/ui/pages/welcome_page.dart';

class RouterService {
  final GoRouter router;
  final GlobalKey<NavigatorState> key;

  RouterService({required this.key})
    : router = GoRouter(
        navigatorKey: key,
        initialLocation: '/',
        routes: _routes,
      );

  static final _routes = [
    GoRoute(
      path: '/',
      builder: (context, state) => AuthGuard(
        fallback: () => context.pushReplacement("/welcome"),
        child: HomePage(),
      ),
    ),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/create_home',
      builder: (context, state) => const CreateHomePage(),
    ),
    GoRoute(
      path: '/invite_after_create',
      builder: (context, state) =>
          InviteAfterCreateHome(invite: state.extra as Invite),
    ),
    GoRoute(
      path: '/join_home',
      builder: (context, state) {
        if (state.extra is Invite) {
          return JoinHomePage(invite: state.extra as Invite);
        }
        return JoinHomePage();
      },
    ),
    GoRoute(
      path: '/join_confirm',
      builder: (context, state) => JoinConfirm(invite: state.extra as Invite),
    ),
  ];
}
