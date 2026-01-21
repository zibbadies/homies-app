import 'package:dio/dio.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/lists.dart';

class ListsApi {
  final Dio dio;
  ListsApi(this.dio);

  Future<ListsResponse> getLists() async {
    try {
      final res = await dio.get('/lists/');
      return ListsResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is! String) {
        final errorData = e.response!.data;
        throw ErrorWithCode.fromJson(errorData);
      }
      throw ErrorWithCode(
        code: "internal_error",
        message: 'Network error occurred',
      );
    } catch (e) {
      throw ErrorWithCode(
        code: "internal_error",
        message: 'An unexpected error occured',
      );
    }
  }

  Future<ItemsResponse> getItemsFromList(String listId) async {
    try {
      final res = await dio.get('/lists/$listId/');
      return ItemsResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is! String) {
        final errorData = e.response!.data;
        throw ErrorWithCode.fromJson(errorData);
      }
      throw ErrorWithCode(
        code: "internal_error",
        message: 'Network error occurred',
      );
    } catch (e) {
      throw ErrorWithCode(
        code: "internal_error",
        message: 'An unexpected error occured',
      );
    }
  }
}
