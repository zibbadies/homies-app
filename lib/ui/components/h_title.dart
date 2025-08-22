import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class HTitle extends StatelessWidget {
  const HTitle({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style ?? context.texts.headlineLarge,
        children: <TextSpan>[
          TextSpan(text: text),
          TextSpan(
            text: '.',
            style: TextStyle(color: context.colors.primary),
          ),
        ],
      ),
    );
  }
}

