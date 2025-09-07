import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/data/repos/home_repo.dart';
import 'package:homies/providers/home/home_provider.dart';

class CreateHomeNotifier extends AsyncNotifier<Invite> {
  HomeRepository get _repo => ref.read(homeRepositoryProvider);

  @override
  Invite build() {
    return const Invite(invite: "");
  }

  Future<void> create(String name) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final invite = await _repo.create(name);
      return invite;
    });
  }
}

final createHomeProvider = AsyncNotifierProvider<CreateHomeNotifier, Invite>(
  CreateHomeNotifier.new,
);
