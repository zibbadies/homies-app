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
                child: HAvatar(avatar: overview.user.avatar, size: 40),
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
              SizedBox(height: 48),

              HTitle(
                text: overview.home.name,
                style: context.texts.headlineLarge,
              ),

              SizedBox(height: 32),

              WeekCalendar(),

              SizedBox(height: 48),

              Text("Today's Tasks", style: context.texts.headlineMedium),
            ],
          ),
        ),
      ),
      error: (e, stack) => Scaffold(
        backgroundColor: context.colors.surface,
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(overviewProvider.future),
          child: Center(
            child: Text(
              e is ErrorWithCode ? e.message : e.toString(),
              style: context.texts.titleSmall!.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        ),
      ),
      loading: () => Text("Loading"),
    );
  }
}

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final selectedIndex = DateTime.now().weekday - 1; // monday based

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final totalSpacing = (days.length - 1) * spacing;
        final boxSize =
            (constraints.maxWidth - totalSpacing - 16) / days.length;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.colors.onSurface.withValues(alpha: 0.25),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final isSelected = index == selectedIndex;
              return Container(
                width: boxSize,
                height: boxSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  days[index],
                  style: context.texts.labelMedium!.copyWith(
                    color: isSelected
                        ? context.colors.onPrimary
                        : context.colors.onSecondary,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
