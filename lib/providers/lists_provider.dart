import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/dio_provider.dart';
import 'package:homies/data/sources/lists_api.dart';
import 'package:homies/data/repos/lists_repo.dart';
import 'package:homies/data/models/lists.dart';
import 'package:homies/providers/user_provider.dart';

final listsApiProvider = Provider((ref) => ListsApi(ref.watch(dioProvider)));
final listsRepositoryProvider = Provider(
  (ref) => ListsRepository(ref.watch(listsApiProvider)),
);

final todoListIdProvider = FutureProvider<ListId>(
  (ref) => ref.read(listsRepositoryProvider).getTodoList(),
);

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Item>>(
  TodoListNotifier.new,
);

/// Todo list state. Mutations are optimistic (the UI updates immediately and
/// rolls back on failure); addItem refetches after success because the API
/// returns `{}` on create and the optimistic item carries a temporary id.
class TodoListNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() async {
    final listId = await _todoListId();

    return ref.read(listsRepositoryProvider).getItemsFromList(listId);
  }

  Future<String> _todoListId() async =>
      (await ref.read(todoListIdProvider.future)).id;

  Future<void> addItem(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final current = state.value ?? [];

    final newItem = Item(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      authorId: ref.read(userProvider).valueOrNull?.uid ?? '',
      completed: false,
    );

    state = AsyncValue.data([newItem, ...current]);

    try {
      final listId = await _todoListId();
      await ref.read(listsRepositoryProvider).addItemToList(trimmed, listId);
      // Replace the temp item with the real server-side items.
      ref.invalidateSelf();
    } catch (_) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  Future<void> editItem(String text, String id) async {
    await _mutate(
      id,
      (item) => item.copyWith(text: text),
      (listId) => ref
          .read(listsRepositoryProvider)
          .editItem(text, listId, id),
    );
  }

  Future<void> deleteItem(String id) async {
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((i) => i.id != id).toList());

    try {
      final listId = await _todoListId();
      await ref.read(listsRepositoryProvider).deleteItem(listId, id);
    } catch (_) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  Future<void> markItemAs(bool completed, String id) async {
    await _mutate(
      id,
      (item) => item.copyWith(completed: completed),
      (listId) => ref
          .read(listsRepositoryProvider)
          .markItemAs(listId, id, completed),
    );
  }

  Future<void> _mutate(
    String id,
    Item Function(Item) transform,
    Future<void> Function(String listId) apiCall,
  ) async {
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.map((i) => i.id == id ? transform(i) : i).toList(),
    );

    try {
      final listId = await _todoListId();
      await apiCall(listId);
    } catch (_) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}
