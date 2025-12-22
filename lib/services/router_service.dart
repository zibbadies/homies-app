import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:homies/data/models/home.dart';
import 'package:homies/ui/components/auth_guard.dart';
import 'package:homies/ui/components/home_guard.dart';
import 'package:homies/ui/pages/create_home/create_home.dart';
import 'package:homies/ui/pages/create_home/invite_after_create_home.dart';
import 'package:homies/ui/pages/home/home_page.dart';
import 'package:homies/ui/pages/join_home/join_confirm.dart';
import 'package:homies/ui/pages/join_home/join_home.dart';
import 'package:homies/ui/pages/loading_page.dart';
import 'package:homies/ui/pages/login/login_page.dart';
import 'package:homies/ui/pages/register/register_page.dart';
import 'package:homies/ui/pages/settings_page.dart';
import 'package:homies/ui/pages/todo/todo_page.dart';
import 'package:homies/ui/pages/welcome_page.dart';

class RouterService {
  final GoRouter router;
  final GlobalKey<NavigatorState> key;

  RouterService({required this.key})
    : router = GoRouter(
        navigatorKey: key,
        initialLocation: '/loading',
        routes: _routes,
      );

  static final _routes = [
    GoRoute(
      path: '/loading',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoadingPage()),
    ),

    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: WelcomePage()),
    ),

    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomeGuard(child: HomePage())),
    ),

    GoRoute(
      path: '/todo',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomeGuard(child: TodoPage())),
    ),

    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: RegisterPage()),
    ),

    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoginPage()),
    ),

    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AuthGuard(child: SettingsPage())),
    ),

    GoRoute(
      path: '/create_home',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AuthGuard(child: CreateHomePage())),
      routes: [
        GoRoute(
          path: 'invite',
          pageBuilder: (context, state) => NoTransitionPage(
            child: AuthGuard(
              child: InviteAfterCreateHome(invite: state.extra as Invite),
            ),
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/join_home',
      pageBuilder: (context, state) => NoTransitionPage(
        child: state.extra is Invite
            ? AuthGuard(child: JoinHomePage(invite: state.extra as Invite))
            : const AuthGuard(child: JoinHomePage()),
      ),
      routes: [
        GoRoute(
          path: 'confirm',
          pageBuilder: (context, state) => NoTransitionPage(
            child: AuthGuard(child: JoinConfirm(invite: state.extra as Invite)),
          ),
        ),
      ],
    ),
  ];
}
