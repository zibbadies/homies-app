import 'package:dio/dio.dart';
import 'package:homies/data/models/lists.dart';
import 'package:homies/utils/handle_request.dart';

class ListsApi {
  final Dio dio;
  ListsApi(this.dio);

  Future<ListsResponse> getLists() async {
    return handleDioRequest(() async {
      final res = await dio.get('/lists/');
      return ListsResponse.fromJson(res.data);
    });
  }

  Future<ItemsResponse> getItemsFromList(String listId) async {
    return handleDioRequest(() async {
      final res = await dio.get('/lists/$listId/');
      return ItemsResponse.fromJson(res.data);
    });
  }

  Future addItemToList(String text, String listId) async {
    return handleDioRequest(
      () => dio.put('/lists/$listId/', data: {'text': text}),
    );
  }

  // TODO: non so se conviene mettere return bool
  // TODO: change to /item/:id
  Future editItem(String text, String listId, String itemId) async {
    return handleDioRequest(
      () => dio.patch('/lists/$listId/$itemId', data: {'text': text}),
    );
  }

  Future deletItem(String itemId) async {
    return handleDioRequest(() => dio.delete('/item/$itemId'));
  }
}
