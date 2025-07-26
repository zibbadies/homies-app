import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homies")),
      body: Center(child: Text("Welcome to Homies", style: context.texts.headlineMedium)),
    );
  }
}
