import 'package:homies/data/models/lists.dart';
import 'package:homies/data/sources/lists_api.dart';

class ListsRepository {
  final ListsApi api;

  ListsRepository(this.api);

  Future<ListsProvider> getLists() async {
    final res = await api.getLists();

    final lists = ListsProvider(
      todo: res.lists.firstWhere((e) => e.name == "todo"),
      shopping: res.lists.firstWhere((e) => e.name == "shopping"),
    );

    return lists;
  }

  Future<List<Item>> getItemsFromList(String id) async {
    final res = await api.getItemsFromList(id);

    return res.items;
  }

  Future addItemToList(String text, String listId) =>
      api.addItemToList(text, listId);

  Future editItem(String text, String listId, String itemId) async {
    final res = await api.editItem(text, listId, itemId);

    return res.items;
  }

  Future deleteItem(String text, String listId, String itemId) async {
    final res = await api.editItem(text, listId, itemId);

    return res.items;
  }
}
