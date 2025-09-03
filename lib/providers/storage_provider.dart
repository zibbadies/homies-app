import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/services/storage_service.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());
