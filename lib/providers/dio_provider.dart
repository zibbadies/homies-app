import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/services/dio_client.dart';
import 'package:homies/providers/storage_provider.dart';
import 'package:homies/services/storage_service.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final SecureStorageService storage = ref.watch(secureStorageProvider);
  return DioClient(storage: storage, ref: ref);
});

final dioProvider = Provider((ref) => ref.watch(dioClientProvider).dio);
