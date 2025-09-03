import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:homies/providers/auth_provider.dart";
import "package:homies/services/router_service.dart";

final routerServiceProvider = Provider<RouterService>((ref) {
  return RouterService(ref: ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final router = ref.watch(routerServiceProvider).router;

  ref.listen(authProvider, (_, __) => router.refresh());

  return router;
});
