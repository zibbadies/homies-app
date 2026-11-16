import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';

import '../../data/models/calendar.dart';
import '../../extensions/theme_extension.dart';

import 'package:homies/utils/dates.dart';

const _weekdayLabels = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

class HMonthCalendar extends StatelessWidget {
  const HMonthCalendar({
    super.key,
    required this.month,
    required this.selected,
    required this.dueDays,
    required this.onSelect,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;                  // 1st of the visible month
  final DateTime selected;               // date-only
  final Map<DateTime, DueDay> dueDays;   // keyed by date-only DateTime
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final days = monthGridDays(month);

    return Column(
      children: [
        _MonthHeader(month: month, onPrevious: onPrevious, onNext: onNext),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true, // size to content, so it can live inside a ListView
          physics: const NeverScrollableScrollPhysics(), // the page scrolls, not the grid
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 56, // fixed cell height, width comes from the screen
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, i) {
            final day = days[i];
            return _DayCell(
              day: day,
              inMonth: day.month == month.month,
              selected: day == selected,
              dueDay: dueDays[day],
              onTap: () => onSelect(day),
            );
          },
        ),
      ],
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final showYear = month.year != DateTime.now().year;
    final label = DateFormat(showYear ? 'MMMM y' : 'MMMM').format(month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChevronButton(icon: LucideIcons.chevron_left, onTap: onPrevious),
        // fixed width so the chevrons don't jump around between "May" and "September"
        SizedBox(
          width: 144,
          child: Text(label, textAlign: TextAlign.center, style: context.texts.titleLarge),
        ),
        _ChevronButton(icon: LucideIcons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: context.colors.onSurface),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.selected,
    required this.dueDay,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool selected;
  final DueDay? dueDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final texts = context.texts;

    final background = selected
        ? colors.primary
        : inMonth
            ? colors.surface
            : colors.surfaceContainer;
    final foreground = selected
        ? colors.onPrimary
        : inMonth
            ? colors.onSecondary
            : colors.onSurface.withValues(alpha: 0.5);

    final hasDot = dueDay != null && dueDay!.total > 0;
    final allDone = dueDay != null && dueDay!.open == 0;

    // Shadow lives on an outer Container; the inner Material + InkWell keep the
    // ripple inside the rounded corners (DESIGN.md §6 rule 3).
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: (selected || !inMonth)
            ? [
                BoxShadow(
                  color: colors.onSurface.withValues(alpha: 0.25),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none, // lets the dot poke out of the corner like in the mock
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${day.day}', style: texts.bodyLarge?.copyWith(color: foreground)),
                  Text(
                    _weekdayLabels[day.weekday - 1],
                    style: texts.labelMedium?.copyWith(color: foreground),
                  ),
                ],
              ),
              if (hasDot)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // yellow dot on a yellow cell would vanish
                      color: (selected ? colors.onPrimary : colors.primary)
                          .withValues(alpha: allDone ? 0.4 : 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
