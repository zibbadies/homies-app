import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:homies/providers/auth_provider.dart";
import 'package:homies/ui/pages/create_home/create_home.dart';
import 'package:homies/ui/pages/home/home_page.dart';
import 'package:homies/ui/pages/join_home/join_home.dart';
import 'package:homies/ui/pages/login/login_page.dart';
import 'package:homies/ui/pages/register/register_page.dart';
import 'package:homies/ui/pages/welcome_page.dart';

class RouterService {
  final GoRouter router;
  final Ref ref;

  RouterService({required this.ref})
    : router = GoRouter(
        initialLocation: '/',
        routes: _routes,
        redirect: (context, state) => _handleRedirect(context, state, ref),
      );

  static final _routes = [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/create_home', builder: (context, state) => const CreateHomePage()),
    GoRoute(path: '/join_home', builder: (context, state) => const JoinHomePage()),
  ];

  static String? _handleRedirect(
    BuildContext context,
    GoRouterState state,
    Ref ref,
  ) {
    final authState = ref.read(authProvider);

    return authState.when(
      data: (authState) {
        final isLoggedIn = authState.isAuthenticated;
        final wantsToLogin = [
          '/welcome',
          '/register',
          '/login',
        ].contains(state.matchedLocation);

        if (!isLoggedIn && !wantsToLogin) return '/welcome';

        // if (isLoggedIn && wantsToLogin) return '/';
        if (isLoggedIn && wantsToLogin) return '/create_home'; // TODO: change this after HomeProvider

        return null;
      },
      error: (_, __) => null,
      loading: () => null,
    );
  }
}
