import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class HButton extends StatelessWidget {
  const HButton({
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            fixedSize: const Size(double.infinity, 48),
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

