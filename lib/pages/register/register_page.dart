import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homies")),
      backgroundColor: context.colors.surface,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("This could be you!", style: context.texts.titleMedium),
                  SizedBox(height: 12),
                  CircleAvatar(radius: 96),
                  SizedBox(height: 12),
                  Text("Username", style: context.texts.titleLarge),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome\ninto Homies!",
                  style: context.texts.headlineLarge,
                ),
                SizedBox(height: 12),
                Text(
                  "Start by creating an account",
                  style: context.texts.displaySmall,
                ),
                SizedBox(height: 24),
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
                    child: Text("Sign Up", style: context.texts.labelLarge),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go("/register");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      fixedSize: const Size(double.infinity, 56),
                    ),
                    child: Text("I'm aldready like that", style: context.texts.labelLarge!.copyWith(color: context.colors.onSecondary)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
