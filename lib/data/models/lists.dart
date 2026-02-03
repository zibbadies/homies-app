import 'package:homies/data/models/user.dart';

class ListsResponse {
  final List<ListId> lists;

  const ListsResponse({required this.lists});

  factory ListsResponse.fromJson(Map<String, dynamic> json) {
    return ListsResponse(
      lists: (json['lists'] as List).map((e) => ListId.fromJson(e)).toList(),
    );
  }
}

class ListId {
  final String id;
  final String name;

  const ListId({required this.id, required this.name});

  factory ListId.fromJson(Map<String, dynamic> json) {
    return ListId(id: json['id'], name: json['name']);
  }
}

class ListsProvider {
  final ListId todo;
  final ListId shopping;
  ListsProvider({required this.todo, required this.shopping});
}

class ItemsResponse {
  final List<Item> items;

  const ItemsResponse({required this.items});

  factory ItemsResponse.fromJson(Map<String, dynamic> json) {
    return ItemsResponse(
      items: (json['items'] as List).map((e) => Item.fromJson(e)).toList(),
    );
  }
}

class Item {
  final String id;
  final String text;
  final bool completed;
  final String authorId;

  const Item({
    required this.id,
    required this.text,
    required this.completed,
    required this.authorId,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      text: json['text'],
      completed: json['completed'],
      authorId: json['author'],
    );
  }
}
