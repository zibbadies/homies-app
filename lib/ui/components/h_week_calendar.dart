import "package:flutter/material.dart";
import "package:homies/extensions/theme_extension.dart";

class HWeekCalendar extends StatelessWidget {
  const HWeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final selectedIndex = DateTime.now().weekday - 1; // monday based

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final totalSpacing = (days.length - 1) * spacing;
        final boxSize =
            (constraints.maxWidth - totalSpacing - 16) / days.length;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.colors.onSurface.withValues(alpha: 0.25),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final isSelected = index == selectedIndex;
              return Container(
                width: boxSize,
                height: boxSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  days[index],
                  style: context.texts.labelMedium!.copyWith(
                    color: isSelected
                        ? context.colors.onPrimary
                        : context.colors.onSecondary,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
