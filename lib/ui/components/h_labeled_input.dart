import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:homies/extensions/theme_extension.dart';

class HLabeledInput extends StatefulWidget {
  const HLabeledInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscurable = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscurable;

  @override
  State<HLabeledInput> createState() => _HLabeledInputState();
}

class _HLabeledInputState extends State<HLabeledInput> {
  bool _obscured = true;

  bool get obscured => _obscured;

  set obscured(bool value) {
    setState(() {
      _obscured = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 2),
          child: Text(widget.label, style: context.texts.titleSmall),
        ),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cannot be empty.';
            }
            return null;
          },

          obscureText: widget.obscurable ? obscured : false,

          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(left: 12),

            filled: true,
            fillColor: context.colors.surfaceContainer,
            border: DecoratedInputBorder(
              child: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              shadow: BoxShadow(
                color: context.colors.onSurface.withValues(alpha: 0.25),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ),

            hintText: widget.hint,
            hintStyle: context.texts.bodyLarge!.copyWith(
              color: context.colors.onSecondary.withValues(alpha: 0.6),
            ),

            errorStyle: context.texts.titleSmall!.copyWith(
              color: context.colors.error,
            ),

            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                bottom: 12,
                right: 4,
              ),
              child: Icon(widget.icon, size: 24, color: context.colors.onSurface),
            ),
            prefixIconColor: context.colors.onSurface,
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 48),

            suffixIcon: widget.obscurable == true
                ? ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.controller,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) {
                        // because i can't call setState inside a Builder
                        Future.microtask(() => obscured = true);
                        return const SizedBox.shrink();
                      }

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              obscured = !obscured;
                            });
                          },
                          child: Container(
                            width: 48, // square size
                            height: 48,
                            alignment: Alignment.center,
                            child: Icon(
                              obscured
                                  ? LucideIcons.eye
                                  : LucideIcons.eye_closed,
                              size: 24,
                              color: context.colors.onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : null,

            suffixIconColor: context.colors.onSurface,
            suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 48),
          ),
          style: context.texts.bodyLarge!.copyWith(
            color: context.colors.onSurface,
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
      ],
    );
  }
}

// credits to: https://github.com/astoniocom/control_style/blob/master/lib/src/decorated_input_border.dart
class DecoratedInputBorder extends InputBorder {
  DecoratedInputBorder({required this.child, required this.shadow})
    : super(borderSide: child.borderSide);

  final InputBorder child;

  final BoxShadow shadow;

  @override
  bool get isOutline => child.isOutline;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      child.getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      child.getOuterPath(rect, textDirection: textDirection);

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  InputBorder copyWith({
    BorderSide? borderSide,
    InputBorder? child,
    BoxShadow? shadow,
    bool? isOutline,
  }) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scalledChild = child.scale(t);

    return DecoratedInputBorder(
      child: scalledChild is InputBorder ? scalledChild : child,
      shadow: BoxShadow.lerp(null, shadow, t)!,
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final clipPath = Path()
      ..addRect(const Rect.fromLTWH(-5000, -5000, 10000, 10000))
      ..addPath(getInnerPath(rect), Offset.zero)
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    final Paint paint = shadow.toPaint();
    final Rect bounds = rect.shift(shadow.offset).inflate(shadow.spreadRadius);

    canvas.drawPath(getOuterPath(bounds), paint);

    child.paint(
      canvas,
      rect,
      gapStart: gapStart,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );
  }
}
