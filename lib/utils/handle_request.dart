import 'package:dio/dio.dart';
import 'package:homies/data/models/error.dart';

/// Runs [request] and normalizes every failure into an [ErrorWithCode].
Future<T> handleDioRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on ErrorWithCode {
    // Already normalized (e.g. nested call): pass it through unchanged.
    rethrow;
  } on DioException catch (e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      throw ErrorWithCode.fromJson(data);
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const ErrorWithCode(
        code: "network_error",
        message: 'Network error occurred',
      );
    }
    throw ErrorWithCode(
      code: "internal_error",
      message: 'An unexpected error occurred: ${e.message ?? e.type.name}',
    );
  } catch (e) {
    throw ErrorWithCode(
      code: "internal_error",
      message: 'An unexpected error occurred: ${e.toString()}',
    );
  }
}
