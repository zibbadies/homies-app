import 'package:dio/dio.dart';
import 'package:homies/data/models/calendar.dart';
import 'package:homies/data/models/lists.dart';
import 'package:homies/utils/dates.dart';
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

  Future<ItemsResponse> getItemsFromList(String listId, {DateTime? dueOn}) async {
    return handleDioRequest(() async {
      final res = await dio.get(
        '/lists/$listId/',
        queryParameters: dueOn != null ? {'due_on': toApiDay(dueOn)} : null,
      );
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

  Future markItemAs(String listId, String itemId, bool completed) async {
    return handleDioRequest(
      () => dio.patch('/lists/$listId/$itemId', data: {
        'completed': completed,
      }),
    );
  }

  Future deleteItem(String listId, String itemId) async {
    return handleDioRequest(() => dio.delete('/lists/$listId/$itemId'));
  }

  Future<List<DueDay>> getDueDays(DateTime from, DateTime to) async {
    return handleDioRequest(() async {
      final res = await dio.get(
        '/lists/due-days',
        queryParameters: {'from': toApiDay(from), 'to': toApiDay(to)},
      );
      return (res.data['days'] as List)
          .map((d) => DueDay.fromJson(d as Map<String, dynamic>))
          .toList();
    });
  }
}
