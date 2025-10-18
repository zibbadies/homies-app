import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';

class InviteAfterCreateHome extends StatelessWidget {
  final Invite invite;

  const InviteAfterCreateHome({super.key, required this.invite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        actions: [SettingsAvatarButton()],
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(
          alpha: 0.25,
        ), // Shadow color
      ),
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HTitle(text: "Invite\nyour Homies"),

                SizedBox(height: 12),

                Text(
                  "They use this code to join!",
                  style: context.texts.displaySmall,
                ),

                SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: invite.code));
                    /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copied to clipboard!',
                          style: context.texts.bodyMedium!.copyWith(
                            color: context.colors.surface,
                          ),
                        ),
                      ),
                    );*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.copy,
                          size: 24,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(invite.code, style: context.texts.headlineLarge),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                HButton(
                  text: "Share Link",
                  color: context.colors.primary,
                  onPressed: () {},
                ),

                SizedBox(height: 12),

                HButton(
                  text: "Continue",
                  color: context.colors.secondary,
                  textColor: context.colors.onSecondary,
                  onPressed: () => context.go("/loading"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
