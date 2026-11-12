import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/connectivity_provider.dart';
import 'package:homies/providers/lists_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_navbar.dart';
import 'package:homies/ui/components/h_offline_card.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_task_tile.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    final user = ref.watch(userProvider).valueOrNull;
    final home = ref.watch(homeProvider).valueOrNull;
    final isOnline = ref.watch(connectivityProvider);
    // Ignore the stale error carried by a refresh in progress.
    final todoError = todoList.isLoading ? null : todoList.error;
    final showCard = !isOnline || todoError != null;
    final cardMessage = !isOnline
        ? "You're offline — some data may be unavailable"
        : todoError is ErrorWithCode
        ? todoError.message
        : 'Something went wrong';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: HTitle(text: "Homies", style: context.texts.titleLarge),
          actions: const [SettingsAvatarButton()],
          scrolledUnderElevation: 1,
          surfaceTintColor: context.colors.surface,
          backgroundColor: context.colors.surface,
          shadowColor: context.colors.onSurface.withValues(alpha: 0.25),
        ),
        backgroundColor: context.colors.surface,
        bottomNavigationBar: const HNavBar(currentIndex: 1),
        body: Column(
          children: [
            if (showCard)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: HOfflineCard(
                  message: cardMessage,
                  icon: isOnline
                      ? LucideIcons.cloud_off
                      : LucideIcons.wifi_off,
                  onRetry: () => ref.invalidate(todoListProvider),
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(todoListProvider.future),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      IgnorePointer(
                        ignoring: !todoList.hasValue,
                        child: Opacity(
                          opacity: todoList.hasValue ? 1.0 : 0.5,
                          child: const NewTaskTile(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: todoList.when(
                          data: (data) => ListView(
                            clipBehavior: Clip.none,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              ...data.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 12.0,
                                  ),
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
                                                    (m) =>
                                                        m.uid ==
                                                        item.authorId,
                                                  )
                                                  ?.avatar,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                          // The card above already reports the error and
                          // offers retry; keep the area empty but
                          // scrollable so pull-to-refresh still works.
                          error: (e, _) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [SizedBox(height: 200)],
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTaskTile extends ConsumerStatefulWidget {
  const NewTaskTile({super.key});

  @override
  ConsumerState<NewTaskTile> createState() => _NewTaskTileState();
}

class _NewTaskTileState extends ConsumerState<NewTaskTile> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await ref.read(todoListProvider.notifier).addItem(text);
      _controller.clear();
    } catch (e) {
      if (mounted) showTaskError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
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

      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
        minVerticalPadding: 0,

        title: TextField(
          autofocus: false,
          controller: _controller,
          style: context.texts.bodyLarge!.copyWith(
            color: context.colors.onSurface,
          ),
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "New Task...",
            hintStyle: context.texts.bodyLarge!.copyWith(
              color: context.colors.onSecondary.withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onSubmitted: _submit,
        ),
        trailing: HButton(
          onPressed: () => _submit(_controller.text),
          height: 36,
          width: 36,
          borderRadius: 8,
          iconSize: 20,
          shadow: false,
          color: context.colors.primary,
          icon: LucideIcons.plus,
        ),
      ),
    );
  }
}
