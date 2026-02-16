import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class HButton extends StatelessWidget {
  const HButton({
    super.key,
    this.text = "",
    this.icon,
    this.iconSize = 24,
    required this.color,
    this.textColor,
    this.width = double.infinity,
    this.height = 48,
    this.borderRadius = 16,
    this.shadow = true,
    this.loading = false,
    this.loadingColor,
    this.onPressed,
  });

  final String text;
  final Color color;
  final IconData? icon;
  final double iconSize;
  final Color? textColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool shadow;
  final bool loading;
  final Color? loadingColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: context.colors.onSurface.withValues(alpha: 0.25),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed: () {
            // unfocus all before the callback
            FocusScope.of(context).unfocus();
            if (onPressed != null) onPressed!();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: color,
            foregroundColor: textColor ?? context.colors.onSurface,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            fixedSize: const Size(double.infinity, double.infinity),
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: iconSize,
                        color: textColor ?? context.colors.onSurface,
                      ),
                      if (text.isNotEmpty) ...[const SizedBox(width: 8)],
                    ],
                    Text(
                      text,
                      style: context.texts.labelLarge!.copyWith(
                        color: textColor ?? context.colors.onSurface,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
