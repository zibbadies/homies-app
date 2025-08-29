import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/services/storage.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());
