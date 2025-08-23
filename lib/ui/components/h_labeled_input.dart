import 'package:flutter/material.dart';
import 'package:homies/extensions/theme_extension.dart';

class HLabeledInput extends StatefulWidget {
  const HLabeledInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscurable = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
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
              controller: widget.controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty.';
                }
                return null;
              },

              obscureText: widget.obscurable ? obscured : false,

              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: context.colors.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
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
                  child: Icon(Icons.person_rounded, size: 24),
                ),
                prefixIconColor: context.colors.onSurface,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 48,
                ),

                suffixIcon: widget.obscurable == true
                    ? ValueListenableBuilder<TextEditingValue>(
                        valueListenable: widget.controller,
                        builder: (context, value, child) {
                          if (value.text.isEmpty) {
                            // TODO: obscured reset when text is empty
                            return const SizedBox.shrink();
                          }

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // makes splash square
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
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : null,

                suffixIconColor: context.colors.onSurface,
                suffixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 48,
                ),
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
