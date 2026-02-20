import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/lists_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_navbar.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_task_tile.dart';
import 'package:homies/ui/pages/create_home/settings_avatar_button.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.refresh(overviewProvider);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      RouteObserver<PageRoute>().subscribe(this, route);
    }
  }

  @override
  void dispose() {
    RouteObserver<PageRoute>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // ref.refresh(overviewProvider);
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoListProvider);
    final user = ref.read(userProvider).value!;
    final home = ref.read(homeProvider).value!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: HTitle(text: "Homies", style: context.texts.titleLarge),
          actions: [SettingsAvatarButton()],
          scrolledUnderElevation: 1,
          surfaceTintColor: context.colors.surface,
          backgroundColor: context.colors.surface,
          shadowColor: context.colors.onSurface.withValues(
            alpha: 0.25,
          ), // Shadow color
        ),
        backgroundColor: context.colors.surface,

        bottomNavigationBar: HNavBar(currentIndex: 1),

        body: RefreshIndicator(
          onRefresh: () async => ref.invalidate(todoListProvider),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: todoList.when(
              data: (data) => ListView(
                clipBehavior: Clip.none,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 24),

                  NewTaskTile(),

                  SizedBox(height: 12),

                  ...data.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: HTaskTile(
                        key: ValueKey(item.id),
                        id: item.id,
                        text: item.text,
                        completed: item.completed,
                        avatar: item.authorId == user.uid
                            ? user.avatar
                            : home.members
                                  .firstWhereOrNull(
                                    (m) => m.uid == item.authorId,
                                  )
                                  ?.avatar,
                        onToggle: (_) {},
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e is ErrorWithCode ? e.message : 'Something went wrong',
                      style: context.texts.titleSmall!.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    HButton(
                      onPressed: () => ref.invalidate(todoListProvider),
                      text: "Retry",
                      color: context.colors.secondary,
                      textColor: context.colors.onSecondary,
                    ),
                  ],
                ),
              ),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}

class NewTaskTile extends ConsumerWidget {
  NewTaskTile({super.key});

  final newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          controller: newTaskController,
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
          onSubmitted: (value) {
            if (value.isEmpty) return;

            ref.read(todoListProvider.notifier).addItem(value);
            newTaskController.clear();
          },
        ),
        trailing: HButton(
          onPressed: () {
            final text = newTaskController.text;
            if (text.isEmpty) return;

            ref.read(todoListProvider.notifier).addItem(text);
            newTaskController.clear();
          },
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
