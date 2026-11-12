import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void redirect(BuildContext context, String path) {
  // addPostFrameCallback does NOT request a frame: on a static screen (e.g.
  // LoadingPage) nothing would ever schedule one and the navigation would
  // stall until some unrelated event produces a frame. Force one here.
  WidgetsBinding.instance.scheduleFrame();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (context.mounted) {
      context.go(path);
    }
  });
}
