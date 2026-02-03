import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/dio_provider.dart';
import 'package:homies/data/sources/lists_api.dart';
import 'package:homies/data/repos/lists_repo.dart';
import 'package:homies/data/models/lists.dart';

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
    final repo = ref.read(listsRepositoryProvider);

    final lists = await ref.watch(listsProvider.future);
    final todo = lists.todo;

    return repo.getItemsFromList(todo.id);
  }

  /*
  /// ➕ Add item (optimistic)
  Future<void> addItem(String text) async {
    final current = state.value ?? [];

    // optimistic UI
    state = AsyncData([
      ...current,
      Item.temp(text), // or however you create temp items
    ]);

    try {
      final newItem = await _repo.addItem(text);
      state = AsyncData([
        ...current,
        newItem,
      ]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

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
  /// 🔄 Full refresh
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
