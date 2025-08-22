import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HTitle(text: "CHOOSE\nYOUR AVATAR"),

                SizedBox(height: 12),

                Text(
                  "Start by creating an account.",
                  style: context.texts.displaySmall,
                ),

                SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 80),
                      SizedBox(height: 12),
                      Text("Username", style: context.texts.titleLarge),
                    ],
                  ),
                ),

                SizedBox(height: 36),

                HButton(
                  text: "Generate Another",
                  color: context.colors.secondary,
                  textColor: context.colors.onSecondary,
                  onPressed: () {},
                ),

                SizedBox(height: 12),

                HButton(
                  text: "Confirm",
                  color: context.colors.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Placeholder()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
