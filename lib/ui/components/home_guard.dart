import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/auth_guard.dart';
import 'package:homies/utils/redirect.dart';

class HomeGuard extends ConsumerWidget {
  final Widget child;

  const HomeGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(homeProvider, (prev, next) {
      // Skip refreshing states: they replay the previous error (see
      // loading_page.dart) and must not trigger a redirect.
      if (next.isLoading) return;
      next.when(
        data: (data) => null,
        error: (e, __) {
          if (e is ErrorWithCode) {
            if (e.code == "user_not_in_house") {
              return redirect(context, "/create_home");
            }
          }
        },
        loading: () => null,
      );
    });

    return AuthGuard(child: child);
  }
}
