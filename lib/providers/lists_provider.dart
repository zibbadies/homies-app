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

final listsProvider = FutureProvider<ListsProvider>(
  (ref) => ref.read(listsRepositoryProvider).getLists(),
);

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Item>>(
  TodoListNotifier.new,
);

// una quantita di acqua esagerata sta venendo usata per creare homies.
class TodoListNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() async {
    final lists = await ref.read(listsProvider.future);
    final todo = lists.todo;

    return ref.read(listsRepositoryProvider).getItemsFromList(todo.id);
  }

  /// ➕ Add item (optimistic)
  Future<void> addItem(String text) async {
    final current = state.value ?? [];

    final newItem = Item(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      authorId: ref.read(userProvider).valueOrNull?.uid ?? "DaiForza",
      completed: false,
    );

    state = AsyncValue.data([newItem, ...current]);

    try {
      final lists = await ref.read(listsProvider.future);
      await ref
          .read(listsRepositoryProvider)
          .addItemToList(text, lists.todo.id);
    } catch (e, _) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  /*
  /// ❌ Delete item (optimistic)
  Future<void> deleteItem(String id) async {
    final current = state.value ?? [];

    state = AsyncData(
      current.where((i) => i.id != id).toList(),
    );

    try {
      await _repo.deleteItem(id);
    } catch (e, st) {
      // rollback
      state = AsyncData(current);
    }
  }

*/
}
