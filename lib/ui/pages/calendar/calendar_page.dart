import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:homies/providers/calendar_provider.dart';
import 'package:homies/ui/components/h_month_calendar.dart';

import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_navbar.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cal = ref.watch(calendarProvider);          // rebuilds when state changes
    final notifier = ref.read(calendarProvider.notifier); // just to call methods
    final dueDays = ref.watch(dueDaysProvider(cal.month));

    return Scaffold(
        appBar: AppBar(
          title: HTitle(text: "Homies", style: context.texts.titleLarge),
          actions: const [SettingsAvatarButton()],
          scrolledUnderElevation: 1,
          surfaceTintColor: context.colors.surface,
          backgroundColor: context.colors.surface,
          shadowColor: context.colors.onSurface.withValues(alpha: 0.25),
        ),
        backgroundColor: context.colors.surface,
        bottomNavigationBar: const HNavBar(currentIndex: 2),
        body: ListView(
            physics: const AlwaysScrollableScrollPhysics(), // TODO: check if this is necessary
            padding: const EdgeInsets.all(24),
            children: [
              HMonthCalendar(
                month: cal.month,
                selected: cal.selected,
                dueDays: dueDays.value ?? const {},
                onSelect: notifier.select,
                onPrevious: () => notifier.changeMonth(-1),
                onNext: () => notifier.changeMonth(1),
              ),
            ],
          )
    )
    /* ))) */;
  }
}
