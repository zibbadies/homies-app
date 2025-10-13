import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void redirect(BuildContext context, String path) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (context.mounted) {
      context.go(path);
    }
  });
}
