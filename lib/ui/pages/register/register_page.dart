import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    void handleRegister() {
      if (_formKey.currentState!.validate()) {
        authNotifier.register(
          usernameController.text.trim(),
          passwordController.text.trim(),
        );
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HTitle(text: "Welcome\ninto Homies"),

          SizedBox(height: 12),

          Text(
            "Start by creating an account",
            style: context.texts.displaySmall,
          ),

          SizedBox(height: 24),

          HLabeledInput(
            label: "Username",
            hint: "Splarpo",
            icon: LucideIcons.user_round,
            controller: usernameController,
          ),

          SizedBox(height: 8),

          HLabeledInput(
            label: "Password",
            hint: "Pa\$\$w0rd",
            icon: LucideIcons.lock,
            controller: passwordController,
            obscurable: true,
          ),

          SizedBox(height: 24),

          authState.when(
            data: (auth) {
              print("dai forza");
              if (auth.isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  context.go('/');
                });
              }

              return HButton(
                text: "Sign Up",
                color: context.colors.primary,
                onPressed: () => handleRegister(),
              );
            },
            loading: () => HButton(
              color: context.colors.primary,
              loading: true,
              loadingColor: context.colors.onPrimary,
            ),
            error: (error, stack) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (error.toString().isNotEmpty) ...[
                  Text(
                    error.toString(),
                    style: context.texts.titleSmall!.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                HButton(
                  text: "Try Again",
                  color: context.colors.primary,
                  onPressed: () => handleRegister(),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          HButton(
            text: "I already have an account",
            color: context.colors.secondary,
            textColor: context.colors.onSecondary,
            onPressed: () {
              if (!mounted || authState.isLoading) return;
              context.push('/login');
              authNotifier.reset();
            },
          ),
        ],
      ),
    );
  }
}
