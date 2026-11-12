// Smoke test: the app boots inside a ProviderScope and renders the initial
// loading page. Network calls fail fast in the test environment; we only
// assert that the widget tree comes up without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:homies/main.dart';
import 'package:homies/ui/pages/loading_page.dart';

void main() {
  testWidgets('app boots and renders the loading page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(LoadingPage), findsOneWidget);

    // Let pending async work settle: in the test environment the API calls
    // fail fast, so LoadingPage's listener eventually redirects (e.g. to
    // /welcome). The explicit time advances flush zero-duration timers Dio
    // schedules, which pumpAndSettle alone leaves pending.
    for (var i = 0; i < 3; i++) {
      await tester.pumpAndSettle(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 1));
    }
  });
}
