import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/utils/redirect.dart';


// Sarebbe tipo il aso di eliminare questa pagina e usare la home come pagina loading, e capire perche non vanno i guard;
class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Read (and thus initialize) homeProvider exactly once, before build's
    // ref.listen subscribes. On a cold start this kicks off the fetch;
    // invalidating on top of it would fire a duplicate request, since
    // listening initializes the provider anyway.
    final initial = ref.read(homeProvider);
    // Only when /loading is re-entered with an already settled (stale)
    // result — e.g. after registering — force a fresh fetch after the first
    // frame. (Modifying providers during build/initState is not allowed.)
    if (!initial.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.invalidate(homeProvider);
        }
      });
    }
  }

  /// Waits for authProvider to resolve (secure-storage token read), then
  /// sends a logged-in user into the app even though the fetch failed,
  /// or to /welcome when there's no session at all.
  Future<void> _redirectAfterAuthResolves() async {
    try {
      final auth = await ref.read(authProvider.future);
      if (!mounted) return;
      redirect(context, auth.isAuthenticated ? "/" : "/welcome");
    } catch (_) {
      if (!mounted) return;
      redirect(context, "/welcome");
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Home>>(homeProvider, (prev, next) {
      // While refreshing, AsyncValue keeps the PREVIOUS error/value and
      // when() would replay it (skipLoadingOnRefresh). Only react to
      // settled states, or a stale user_not_in_house error would bounce
      // the user to /create_home even after a successful create+refetch.
      if (next.isLoading) return;

      next.when(
        data: (_) => redirect(context, "/"),
        error: (e, _) {
          if (e is ErrorWithCode &&
              ["not_authenticated", "user_not_found"].contains(e.code)) {
            ref.read(authProvider.notifier).reset();
            redirect(context, "/register");
          } else if (e is ErrorWithCode && e.code == "user_not_in_house") {
            redirect(context, "/create_home");
          } else {
            // Network/server error (e.g. no internet, server down): a
            // logged-in user must NOT be kicked to the welcome/login
            // screens. authProvider may still be resolving (the secure
            // storage read is async and slower than a connection refusal),
            // so wait for it before deciding where to go.
            _redirectAfterAuthResolves();
          }
        },
        loading: () => null,
      );
    });
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(child: HTitle(text: "Sto Caricando")),
    );
  }
}
