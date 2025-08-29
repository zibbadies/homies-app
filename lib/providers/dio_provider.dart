import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/services/dio_client.dart';
import 'package:homies/providers/storage_provider.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioClient(storage: storage);
});

final dioProvider = Provider((ref) => ref.watch(dioClientProvider).dio);
