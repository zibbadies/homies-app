import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Guard extends StatelessWidget {
  final Future<bool> canActivate;
  final Widget child;
  final String fallbackRoute;

  const Guard({
    super.key,
    // this is the condition to check within a Future as it can be async
    required this.canActivate,
    // this is the child to display if the condition is met
    required this.child,
    // this is the route to redirect if the condition is not met
    required this.fallbackRoute,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: canActivate,
      builder: (_, result) {
        if (!result.hasData || result.hasError) {
          return Container();
        }
        final bool canActivate = result.data!;
        if (canActivate) {
          return child;
        }
        redirect(context);
        return Container();
      },
    );
  }

  void redirect(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.pushReplacement(fallbackRoute);
    });
  }
}
