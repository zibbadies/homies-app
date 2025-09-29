import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import 'package:homies/data/models/home.dart';
import "package:homies/providers/auth_provider.dart";
import 'package:homies/providers/user_provider.dart';
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
  final Ref ref;

  RouterService({required this.ref})
    : router = GoRouter(
        initialLocation: '/',
        refreshListenable: _GoRouterRefreshNotifier(ref),
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

  static String? _handleRedirect(
    BuildContext context,
    GoRouterState state,
    Ref ref,
  ) {
    final authState = ref.read(authProvider);
    final overviewState = ref.read(overviewProvider);

    return authState.when(
      data: (authData) {
        final isLoggedIn = authData.isAuthenticated;
        final wantsToLogin = [
          '/welcome',
          '/register',
          '/login',
        ].contains(state.matchedLocation);
        final isCreatingHome = state.matchedLocation == '/create_home';
        final isJoiningHome = [
          '/join_home',
          '/join_confirm',
        ].contains(state.matchedLocation);
        
        // Not Logged in
        if (!isLoggedIn) {
          return wantsToLogin ? null : '/welcome';
        }

        // Logged in - check home status
        return overviewState.when(
          data: (overview) {
            // Has home
            if (wantsToLogin || isCreatingHome) return '/';
            return null;
          },
          error: (e, _) {
            // Hasn't home TODO: check the specific error for no_home
            if (isCreatingHome || isJoiningHome) return null;
            return '/create_home';
          },
          loading: () => null,
        );
      },
      error: (_, __) => null,
      loading: () => null,
    );
  }
}

// Add this class to make the router react to state changes
class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
    ref.listen(overviewProvider, (_, __) => notifyListeners());
  }
}
