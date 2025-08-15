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
                  CircleAvatar(radius: 64),
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 2),
                      child: Text("Username", style: context.texts.titleSmall),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.onSurface.withValues(
                              alpha: 0.25,
                            ),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Non puo rimanere vuotol';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(
                            48,
                            16,
                            12,
                            16,
                          ),
                          filled: true,
                          fillColor: context.colors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Splarpo",
                          hintStyle: context.texts.bodyLarge!.copyWith(
                            color: context.colors.onSecondary.withValues(
                              alpha: 0.6,
                            ),
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
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 2),
                      child: Text("Password", style: context.texts.titleSmall),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.onSurface.withValues(
                              alpha: 0.25,
                            ),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Non puo rimanere vuotol';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(
                            48,
                            16,
                            12,
                            16,
                          ),
                          filled: true,
                          fillColor: context.colors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "A\$\$word.",
                          hintStyle: context.texts.bodyLarge!.copyWith(
                            color: context.colors.onSecondary.withValues(
                              alpha: 0.6,
                            ),
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
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.onSurface.withValues(alpha: 0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go("/register");
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: context.colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        fixedSize: const Size(double.infinity, 56),
                      ),
                      child: Text("Sign Up", style: context.texts.labelLarge),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.onSurface.withValues(alpha: 0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go("/register");
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: context.colors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        fixedSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        "I'm aldready like that",
                        style: context.texts.labelLarge!.copyWith(
                          color: context.colors.onSecondary,
                        ),
                      ),
                    ),
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
