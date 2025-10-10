import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/overview.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/utils/redirect.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(overviewProvider);
    ref.listen<AsyncValue<Overview>>(overviewProvider, (prev, next) {
      next.when(
        data: (_) => redirect(context, "/"),
        error: (e, _) {
          if (e is ErrorWithCode) {
            if (e.code == "user_not_in_house") {
              redirect(context, "/create_home");
            } else {
              redirect(context, "/welcome");
            }
          }
        },
        loading: () => null,
      );
    });
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(child: HTitle(text: "Sto Caricando")),
    );
  }
}
