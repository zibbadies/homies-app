import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homies"),
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(
          alpha: 0.25,
        ), // Shadow color
      ),
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "This could be you!",
                                style: context.texts.titleMedium,
                              ),
                              SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.onSurface
                                          .withValues(alpha: 0.25),
                                      spreadRadius: 0,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: CircleAvatar(radius: 64),
                              ),
                              SizedBox(height: 12),
                              Text("Username", style: context.texts.titleLarge),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome\ninto Homies!",
                              style: context.texts.headlineLarge,
                            ),

                            SizedBox(height: 12),

                            Text(
                              "Start by creating an account.",
                              style: context.texts.displaySmall,
                            ),

                            SizedBox(height: 24),

                            HomiesLabeledInput(
                              label: "Username",
                              hint: "Splarpo",
                            ),

                            SizedBox(height: 8),

                            HomiesLabeledInput(
                              label: "Password",
                              hint: "Pa\$\$w0rd",
                            ),

                            SizedBox(height: 16),

                            HomiesButton(
                              text: "Sign Up",
                              color: context.colors.primary,
                              onPressed: () {},
                            ),

                            SizedBox(height: 12),

                            HomiesButton(
                              text: "I already have an account",
                              color: context.colors.secondary,
                              textColor: context.colors.onSecondary,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomiesLabeledInput extends StatelessWidget {
  const HomiesLabeledInput({
    super.key,
    required this.label,
    required this.hint,
  });

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 2),
          child: Text(label, style: context.texts.titleSmall),
        ),

        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: context.colors.onSurface.withValues(alpha: 0.25),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: null, // TODO: Adding Controller Support
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Cannot be empty.';
              }
              return null;
            },
            decoration: InputDecoration(
              // TODO: Icons.
              contentPadding: const EdgeInsets.fromLTRB(48, 16, 12, 16),
              filled: true,
              fillColor: context.colors.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              hintText: hint,
              hintStyle: context.texts.bodyLarge!.copyWith(
                color: context.colors.onSecondary.withValues(alpha: 0.6),
              ),

              errorStyle: context.texts.titleSmall!.copyWith(
                color: context.colors.error,
              ),
            ),
            style: context.texts.bodyLarge!.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class HomiesButton extends StatelessWidget {
  const HomiesButton({
    super.key,
    required this.text,
    required this.color,
    this.textColor,
    required this.onPressed,
  });

  final String text;
  final Color color;
  final Color? textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withValues(alpha: 0.25),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(999),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            fixedSize: const Size(double.infinity, 56),
          ),
          child: Text(
            text,
            style: context.texts.labelLarge!.copyWith(
              color: textColor ?? context.colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
