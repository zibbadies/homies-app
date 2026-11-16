import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/calendar_provider.dart';
import 'package:homies/providers/connectivity_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_navbar.dart';
import 'package:homies/ui/components/h_offline_card.dart';
import 'package:homies/ui/components/h_task_tile.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_week_calendar.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';
import 'package:homies/utils/dates.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// Cached home data older than this is refetched when the page opens;
  /// fresher data is shown as-is (pull-to-refresh still forces a fetch).
  static const _staleAfter = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // A fetch kicked off elsewhere (loading page, connectivity recovery)
      // is already in flight — don't duplicate it.
      if (ref.read(homeProvider).isLoading) return;
      // Cold start lands here right after the loading page fetched, and the
      // navbar recreates this page on every tab switch: only refetch when
      // the cached data actually went stale.
      final fetchedAt = ref.read(homeFreshnessProvider).fetchedAt;
      if (fetchedAt != null &&
          DateTime.now().difference(fetchedAt) < _staleAfter) {
        return;
      }
      ref.refresh(homeProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);
    final isOnline = ref.watch(connectivityProvider);
    final user = ref.watch(userProvider).valueOrNull;
    final today = dateOnly(DateTime.now());
    final dayTasks = ref.watch(dayTasksProvider(today));
    // Ignore the stale error carried by a refresh in progress.
    final homeError = homeAsync.isLoading ? null : homeAsync.error;
    final tasksError = dayTasks.isLoading ? null : dayTasks.error;
    final showCard = !isOnline || homeError != null || tasksError != null;
    final cardMessage = !isOnline
        ? "You're offline — some data may be unavailable"
        : homeError is ErrorWithCode
        ? homeError.message
        : tasksError is ErrorWithCode
        ? tasksError.message
        : "Couldn't load your home";

    // The shell (app bar, error card, navbar) always renders for
    // authenticated users — even offline. Only the content area below
    // depends on the fetch.
    // TODO: show cached home data in the content area when offline
    // (see project-notes ToDo, "Cache offline dei dati").
    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        actions: const [SettingsAvatarButton()],
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(
          alpha: 0.25,
        ), // Shadow color
      ),
      backgroundColor: context.colors.surface,

      bottomNavigationBar: const HNavBar(currentIndex: 0),

      body: Column(
        children: [
          if (showCard)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: HOfflineCard(
                message: cardMessage,
                icon: isOnline ? LucideIcons.cloud_off : LucideIcons.wifi_off,
                onRetry: () {
                  ref.invalidate(homeProvider);
                  ref.invalidate(dayTasksProvider);
                },
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  ref.refresh(homeProvider.future),
                  ref.refresh(dayTasksProvider(today).future),
                ]);
              },
              child: homeAsync.when(
                data: (home) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    const SizedBox(height: 24),

                    HTitle(text: home.name, style: context.texts.headlineLarge),

                    const SizedBox(height: 32),

                    const HWeekCalendar(),

                    const SizedBox(height: 48),

                    Text("Today's Tasks", style: context.texts.headlineMedium),

                    const SizedBox(height: 12),

                    // Same day-tasks logic as the calendar page: HTaskTiles
                    // for the tasks due today (tap opens the task sheet).
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
                                    : home.members
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
                    const SizedBox(height: 24),
                  ],
                ),
                // The card above already reports the error and offers retry;
                // keep an empty scrollable so pull-to-refresh still works.
                error: (e, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [SizedBox(height: 200)],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
