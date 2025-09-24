import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);
    final overviewAsync = ref.watch(overviewProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              overviewAsync.when(
                data: (overview) => HTitle(text: overview.home.name),
                error: (e, _) => Text("Error $e"),
                loading: () => Text("Loading"),
              ),

              SizedBox(height: 24),

              HButton(
                text: "Logout",
                color: context.colors.secondary,
                textColor: context.colors.onSecondary,
                onPressed: () {
                  authNotifier.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
