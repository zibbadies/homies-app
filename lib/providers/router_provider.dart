import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import 'package:homies/data/models/auth_state.dart';
import "package:homies/providers/auth_provider.dart";
import 'package:homies/ui/pages/home/home_page.dart';
import 'package:homies/ui/pages/login/login_page.dart';
import 'package:homies/ui/pages/register/register_page.dart';
import 'package:homies/ui/pages/welcome_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(path: '/welcome', builder: (context, state) => WelcomePage()),
      GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    ],
    redirect: (context, state) {
      return ref
          .read(authProvider)
          .when(
            data: (authState) {
              final isLoggedIn = authState.isAuthenticated;
              final wantsToLogin = [
                '/welcome',
                '/register',
                '/login',
              ].contains(state.matchedLocation);

              if (!isLoggedIn && !wantsToLogin) return '/welcome';

              if (isLoggedIn && wantsToLogin) return '/';

              return null;
            },
            error: (_, __) => null,
            loading: () => null,
          );
    },
  );

  ref.listen(authProvider, (_, __) => router.refresh());

  return router;
});
