import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:homies/data/models/error.dart';
import 'package:homies/providers/calendar_provider.dart';
import 'package:homies/providers/connectivity_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_month_calendar.dart';
import 'package:homies/ui/components/h_offline_card.dart';
import 'package:homies/ui/components/h_task_tile.dart';

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
    final dayTasks = ref.watch(dayTasksProvider(cal.selected));
    final user = ref.watch(userProvider).valueOrNull;
    final home = ref.watch(homeProvider).valueOrNull;
    final isOnline = ref.watch(connectivityProvider);
    // Ignore the stale error carried by a refresh in progress.
    final tasksError = dayTasks.isLoading ? null : dayTasks.error;
    final cardMessage = !isOnline
        ? "You're offline — some data may be unavailable"
        : tasksError is ErrorWithCode
        ? tasksError.message
        : 'Something went wrong';

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
        body: RefreshIndicator(
          onRefresh: () => Future.wait([
            ref.refresh(dueDaysProvider(cal.month).future),
            ref.refresh(dayTasksProvider(cal.selected).future),
          ]),
          child: ListView(
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
              if (tasksError != null || !isOnline)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: HOfflineCard(
                    message: cardMessage,
                    icon: isOnline
                        ? LucideIcons.cloud_off
                        : LucideIcons.wifi_off,
                    onRetry: () => ref.invalidate(dayTasksProvider(cal.selected)),
                  ),
                ),
              const SizedBox(height: 24),
              // Events of the selected day, same tiles as the todo page.
              ...dayTasks.maybeWhen(
                data: (items) => items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: HTaskTile(
                      key: ValueKey(item.id),
                      id: item.id,
                      text: item.text,
                      completed: item.completed,
                      avatar:
                          item.authorId == user?.uid
                              ? user!.avatar
                              : home?.members
                                    .firstWhereOrNull(
                                      (m) => m.uid == item.authorId,
                                    )
                                    ?.avatar,
                    ),
                  ),
                ),
                loading: () => [
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
                orElse: () => [],
              ),
            ],
          ),
        ),
    );
  }
}
