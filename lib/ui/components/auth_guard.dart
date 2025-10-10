import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/utils/redirect.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (prev, next) {
      next.when(
        data: (data) {
          if (!data.isAuthenticated) redirect(context, "/welcome");
        },
        error: (e, __) {
          if (e is ErrorWithCode) {
            if (e.code == "user_not_in_house") {
              return redirect(context, "/create_home");
            }
            if (e.code == "not_authenticated") {
              return redirect(context, "/welcome");
            }
          }
        },
        loading: () => null,
      );
    });

    return child;
  }
}
