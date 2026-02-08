import 'package:dio/dio.dart';
import 'package:homies/data/models/error.dart';

Future<T> handleDioRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
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
      message: 'An unexpected error occurred: ${e.toString()}',
    );
  }
}
