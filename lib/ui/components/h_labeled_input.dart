import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class HLabeledInput extends StatelessWidget {
  const HLabeledInput({
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

        SizedBox(
          height: 48,
          child: Container(
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

                // TODO: Eye Button
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    top: 12,
                    bottom: 12,
                    right: 4,
                  ),
                  child: Icon(Icons.person_rounded, size: 24),
                ),
                prefixIconColor: context.colors.onSurface,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 48,
                ),

                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: context.texts.bodyLarge!.copyWith(
                color: context.colors.onSurface,
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ),
      ],
    );
  }
}

