import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_avatar.dart';
import 'package:homies/ui/components/h_title.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(overviewProvider);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      RouteObserver<PageRoute>().subscribe(this, route);
    }
  }

  @override
  void dispose() {
    RouteObserver<PageRoute>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.refresh(overviewProvider);
  }

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(overviewProvider);

    return overviewAsync.when(
      data: (overview) => Scaffold(
        appBar: AppBar(
          title: HTitle(text: "Homies", style: context.texts.titleLarge),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: GestureDetector(
                onTap: () {
                  if (context.mounted) context.push("/settings");
                },
                child: HAvatar(
                  avatar: overview.user.avatar,
                  size: 40,
                ),
              ),
            ),
          ],
          scrolledUnderElevation: 1,
          surfaceTintColor: context.colors.surface,
          backgroundColor: context.colors.surface,
          shadowColor: context.colors.onSurface.withValues(
            alpha: 0.25,
          ), // Shadow color
        ),
        backgroundColor: context.colors.surface,
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(overviewProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            children: [
              HAvatar(avatar: overview.user.avatar, size: 100),
              SizedBox(height: 24),
              HTitle(text: overview.home.name),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: Text(
                  "Members",
                  style: context.texts.headlineMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: overview.home.members.length,
                  itemBuilder: (context, index) {
                    final member = overview.home.members[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: HAvatar(avatar: member.avatar, size: 50),
                    );
                  },
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      error: (e, stack) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (e is ErrorWithCode) ...[
            Text(
              e.message,
              style: context.texts.titleSmall!.copyWith(
                color: context.colors.error,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
      loading: () => Text("Loading"),
    );
  }
}
