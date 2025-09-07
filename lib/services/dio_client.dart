import 'package:dio/dio.dart';
import 'package:homies/services/storage_service.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storage;

  DioClient({required this.storage})
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
      ),
    );
  }
}
