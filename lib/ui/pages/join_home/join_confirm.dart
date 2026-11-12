import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/home_provider.dart';
import 'package:homies/ui/components/h_avatar.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';

class JoinConfirm extends ConsumerStatefulWidget {
  final Invite invite;

  const JoinConfirm({super.key, required this.invite});

  @override
  ConsumerState<JoinConfirm> createState() => _JoinConfirmState();
}

class _JoinConfirmState extends ConsumerState<JoinConfirm> {
  bool _confirmed = false;

  void _handleConfirm() {
    setState(() {
      _confirmed = true;
    });
    ref.read(joinHomeProvider.notifier).join(widget.invite);
  }

  @override
  Widget build(BuildContext context) {
    final inviteInfoAsync = ref.watch(inviteInfoProvider(widget.invite));
    final joinHomeAsync = ref.watch(joinHomeProvider);

    ref.listen(joinHomeProvider, (prev, next) {
      if (next.valueOrNull == true) {
        context.go('/loading');
      }
    });

    ref.listen(inviteInfoProvider(widget.invite), (prev, next) {
      if (next.hasError) {
        context.go('/join_home', extra: widget.invite);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        actions: const [SettingsAvatarButton()],
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(
          alpha: 0.25,
        ), // Shadow color
      ),
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                inviteInfoAsync.when(
                  data: (inviteInfo) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HTitle(
                          text: "You are going to join ${inviteInfo.name}",
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Do you know these folks?",
                          style: context.texts.displaySmall,
                        ),

                        const SizedBox(height: 36),

                        Center(
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: inviteInfo.members.length,
                              itemBuilder: (context, index) {
                                final member = inviteInfo.members[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      HAvatar(avatar: member.avatar, size: 60),
                                      const SizedBox(height: 8),
                                      Text(
                                        member.name,
                                        style: context.texts.bodyLarge,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (e, stack) {
                    // Navigation back to /join_home happens in the listener.
                    return Column(
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
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

                const SizedBox(height: 36),

                if (!_confirmed)
                  HButton(
                    text: "Confirm and Join",
                    color: context.colors.primary,
                    onPressed: _handleConfirm,
                  )
                else
                  joinHomeAsync.when(
                    data: (_) => HButton(
                      text: "Confirm and Join",
                      color: context.colors.primary,
                      onPressed: _handleConfirm,
                    ),
                    loading: () => HButton(
                      color: context.colors.primary,
                      loading: true,
                      loadingColor: context.colors.onPrimary,
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

                        HButton(
                          text: "Try Again",
                          color: context.colors.primary,
                          onPressed: _handleConfirm,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                HButton(
                  text: "Cancel",
                  color: context.colors.secondary,
                  textColor: context.colors.onSecondary,
                  onPressed: () {
                    context.go("/join_home");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
