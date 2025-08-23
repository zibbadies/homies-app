import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';
import 'package:homies/ui/pages/register/avatar_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameInput = TextEditingController();
    final passwordInput = TextEditingController();

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
                HTitle(text: "WELCOME\nINTO HOMIES"),

                SizedBox(height: 12),

                Text(
                  "Start by creating an account.",
                  style: context.texts.displaySmall,
                ),

                SizedBox(height: 24),

                HLabeledInput(label: "Username", hint: "Splarpo", controller: usernameInput),

                SizedBox(height: 8),

                HLabeledInput(label: "Password", hint: "Pa\$\$w0rd", controller: passwordInput, obscurable: true,),

                SizedBox(height: 24),

                HButton(
                  text: "Sign Up",
                  color: context.colors.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AvatarPage()),
                    );
                  },
                ),

                SizedBox(height: 12),

                HButton(
                  text: "I already have an account",
                  color: context.colors.secondary,
                  textColor: context.colors.onSecondary,
                  onPressed: () {
                    context.go('/login');
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
