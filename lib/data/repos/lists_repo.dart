import 'package:homies/data/models/calendar.dart';
import 'package:homies/data/models/lists.dart';
import 'package:homies/data/sources/lists_api.dart';

class ListsRepository {
  final ListsApi api;

  ListsRepository(this.api);

  /// Resolves the house's `todo` list by name from GET /lists/.
  Future<ListId> getTodoList() async {
    final res = await api.getLists();

    return res.lists.firstWhere((e) => e.name == "todo");
  }

  Future<List<Item>> getItemsFromList(String id) async {
    final res = await api.getItemsFromList(id);

    return res.items;
  }

  Future<void> addItemToList(String text, String listId) =>
      api.addItemToList(text, listId);

  Future<void> editItem(String text, String listId, String itemId) =>
      api.editItem(text, listId, itemId);

  Future<void> deleteItem(String listId, String itemId) =>
      api.deleteItem(listId, itemId);

  Future<void> markItemAs(String listId, String itemId, bool completed) =>
      api.markItemAs(listId, itemId, completed);

  Future<List<DueDay>> getDueDays({required DateTime from, required DateTime to}) =>
      api.getDueDays(from, to);
}
