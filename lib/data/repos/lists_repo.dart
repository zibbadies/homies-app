import 'package:homies/data/models/calendar.dart';
import 'package:homies/data/models/lists.dart';
import 'package:homies/data/sources/lists_api.dart';

class ListsRepository {
  final ListsApi api;

  ListsRepository(this.api);

  Future<ListsPair> getLists() async {
    final res = await api.getLists();

    final lists = ListsPair(
      todo: res.lists.firstWhere((e) => e.name == "todo"),
      shopping: res.lists.firstWhere((e) => e.name == "shopping"),
    );

    return lists;
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


  Future<List<DueDay>> getDueDays({required DateTime from, required DateTime to}) async {
    final due_days = await api.getDueDays(from, to);
    
    return due_days;
  }
}
