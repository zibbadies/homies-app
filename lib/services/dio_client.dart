import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/services/storage_service.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storage;
  final Ref ref;

  DioClient({required this.storage, required this.ref})
    : dio = Dio(BaseOptions(baseUrl: 'https://homies.sgrodolix.website')) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            ref.read(authProvider.notifier).logout();
          }
          return handler.next(response);
        },
      ),
    );
  }
}
