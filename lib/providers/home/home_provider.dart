import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/repos/home_repo.dart';
import 'package:homies/data/sources/home_api.dart';
import 'package:homies/providers/dio_provider.dart';

final homeApiProvider = Provider((ref) => HomeApi(ref.watch(dioProvider)));
final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(ref.watch(homeApiProvider)),
);
