import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/overview.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/utils/redirect.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(
          alpha: 0.25,
        ), // Shadow color
      ),
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HTitle(text: "Settings"),
        
              SizedBox(height: 32),
        
              HButton(
                text: "Logout",
                color: context.colors.secondary,
                textColor: context.colors.onSecondary,
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
