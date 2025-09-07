import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class HButton extends StatelessWidget {
  const HButton({
    super.key,
    this.text = "",
    required this.color,
    this.textColor,
    this.loading = false,
    this.loadingColor,
    this.onPressed,
  });

  final String text;
  final Color color;
  final Color? textColor;
  final bool loading;
  final Color? loadingColor;
  final VoidCallback? onPressed;

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
        child: TextButton(
          onPressed: () {
            // unfocus all before the callback
            FocusScope.of(context).unfocus();
            if (onPressed != null) onPressed!();
          },
          style: TextButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor ?? context.colors.onSurface,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            fixedSize: const Size(double.infinity, 48),
          ),
          child: loading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: loadingColor ?? context.colors.onPrimary,
                    strokeWidth: 3,
                  ),
                )
              : Text(
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
