import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/auth_provider.dart';

import 'package:homies/ui/components/guard.dart';

class AuthGuard extends ConsumerWidget {
  final String fallbackRoute;
  final Widget child;

  const AuthGuard({
    super.key,
    required this.fallbackRoute,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Guard(
      canActivate: authState.when(
        data: (data) async => data.isAuthenticated,
        error: (_, __) async => false,
        loading: () async => false,
      ),
      fallbackRoute: fallbackRoute,
      child: child,
    );
  }
}
