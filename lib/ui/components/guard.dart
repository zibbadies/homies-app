import 'package:flutter/material.dart';

class Guard extends StatelessWidget {
  final Future<bool> canActivate;
  final Widget child;
  final VoidCallback fallback;

  const Guard({
    super.key,
    required this.canActivate,
    required this.child,
    required this.fallback,
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
        redirect();
        return Container();
      },
    );
  }

  void redirect() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => fallback());
  }
}
