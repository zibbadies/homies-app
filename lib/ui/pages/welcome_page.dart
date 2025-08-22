import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
      ),
      backgroundColor: context.colors.surface,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HTitle(text: "Homies", style: context.texts.displayLarge),

            SizedBox(height: 12),

            Text(
              "You and your homies have never been so organized.",
              style: context.texts.displaySmall,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24),

            HButton(
              text: "Start Now",
              color: context.colors.primary,
              onPressed: () {
                context.go("/register");
              },
            ),
          ],
        ),
      ),
    );
  }
}
