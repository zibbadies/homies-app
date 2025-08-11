import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homies")),
      backgroundColor: context.colors.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Homies", style: context.texts.displayLarge),
                  SizedBox(height: 12,),
                  Text(
                    "You and your homies have never been so organized.",
                    style: context.texts.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    context.go("/register");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  fixedSize: const Size(double.infinity, 56),
                ),
                child: Text("Start Now", style: context.texts.labelLarge),
              ),
            ),
            SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }
}
