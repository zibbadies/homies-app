import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:homies/services/router_service.dart";

final routerServiceProvider = Provider<RouterService>((ref) {
  final key = GlobalKey<NavigatorState>();
  return RouterService(key: key);
});

final routerProvider = Provider<GoRouter>((ref) {
  final router = ref.watch(routerServiceProvider).router;
  return router;
});
