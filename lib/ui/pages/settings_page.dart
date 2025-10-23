import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/auth_provider.dart';
import 'package:homies/providers/home_provider.dart';
import 'package:homies/providers/user_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showLeaveModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      barrierColor: context.colors.onSurface.withAlpha(120),
      builder: (context) => const LeaveConfirmationModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(overviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(
          alpha: 0.25,
        ), // Shadow color
      ),
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HTitle(text: "Settings"),

              SizedBox(height: 32),

              HButton(
                text: "Logout",
                color: context.colors.secondary,
                textColor: context.colors.onSecondary,
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
              ),

              overviewAsync.when(
                data: (data) => Column(
                  children: [
                    SizedBox(height: 12),
                    HButton(
                      text: "Leave Home",
                      color: context.colors.error,
                      textColor: context.colors.onError,
                      onPressed: () => _showLeaveModal(context),
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(), // or a spinner
                error: (err, stack) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaveConfirmationModal extends ConsumerStatefulWidget {
  const LeaveConfirmationModal({super.key});

  @override
  ConsumerState<LeaveConfirmationModal> createState() =>
      _LeaveConfirmationModalState();
}

class _LeaveConfirmationModalState
    extends ConsumerState<LeaveConfirmationModal> {
  bool _confirmed = false;

  void _handleConfirm() {
    setState(() {
      ref.invalidate(leaveHomeProvider);
      _confirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<bool>? leaveHomeAsync = _confirmed
        ? ref.watch(leaveHomeProvider)
        : null;

    return SafeArea(
      child: PopScope(
        canPop: !(leaveHomeAsync?.isLoading ?? false),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Are you sure you\nwant to leave ${ref.read(overviewProvider).valueOrNull?.home.name}?",
                  style: context.texts.displaySmall,
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 24),

                leaveHomeAsync == null
                    ? Column(
                        children: [
                          HButton(
                            text: "Confirm and Leave",
                            color: context.colors.error,
                            textColor: context.colors.onError,
                            onPressed: () => _handleConfirm(),
                          ),
                          SizedBox(height: 12),

                          HButton(
                            text: "Cancel",
                            color: context.colors.secondary,
                            textColor: context.colors.onSecondary,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      )
                    : leaveHomeAsync.when(
                        data: (success) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (success) {
                              ref.invalidate(overviewProvider);
                              Navigator.pop(context);
                              context.go('/create_home');
                            }
                          });

                          return Container();
                        },
                        loading: () => Column(
                          children: [
                            HButton(
                              loading: true,
                              color: context.colors.error,
                              loadingColor: context.colors.onError,
                            ),
                            SizedBox(height: 12),

                            HButton(
                              text: "Cancel",
                              color: context.colors.secondary.withAlpha(120),
                              textColor: context.colors.onSecondary,
                            ),
                          ],
                        ),
                        error: (e, stack) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (e is ErrorWithCode) ...[
                              Text(
                                e.message,
                                style: context.texts.titleLarge!.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
