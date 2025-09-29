import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/services/storage_service.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storage;
  final AuthNotifier authNotifier;

  DioClient({
    required this.storage,
    required this.authNotifier,
  }) : dio = Dio(BaseOptions(baseUrl: 'https://homies.sgrodolix.website')) {
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
            authNotifier.logout();
          }
          return handler.next(response);
        },
      ),
    );
  }
}
