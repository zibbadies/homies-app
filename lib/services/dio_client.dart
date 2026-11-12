import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/services/app_config.dart';
import 'package:homies/services/storage_service.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storage;
  final Ref ref;

  DioClient({required this.storage, required this.ref})
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = token.value;
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          // Dio routes non-2xx responses here (not to onResponse), so an
          // expired/invalid JWT surfaces as a 401 DioException. logout() is
          // idempotent, so parallel 401s don't cause a loop.
          if (e.response?.statusCode == 401) {
            await ref.read(authProvider.notifier).logout();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
