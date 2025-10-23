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
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<InviteInfo> inviteInfoAsync = ref.watch(
      inviteInfoProvider(widget.invite),
    );
    final AsyncValue<bool>? joinHomeAsync = _confirmed
        ? ref.watch(joinHomeProvider(widget.invite))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        actions: [SettingsAvatarButton()],
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

                        SizedBox(height: 12),

                        Text(
                          "Do you know these folks?",
                          style: context.texts.displaySmall,
                        ),

                        SizedBox(height: 36),

                        Center(
                          child: SizedBox(
                            height: 92,
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
                                      SizedBox(height: 8),
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/join_home', extra: widget.invite);
                    });

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
                  loading: () => Text("loading"), // handle better loading
                ),

                SizedBox(height: 36),

                joinHomeAsync == null
                    ? HButton(
                        text: "Confirm and Join",
                        color: context.colors.primary,
                        onPressed: () => _handleConfirm(),
                      )
                    : joinHomeAsync.when(
                        data: (success) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (success) {
                              context.go('/loading');
                            }
                          });

                          return HButton(
                            text: "Confirm and Join",
                            color: context.colors.primary,
                            onPressed: () => _handleConfirm(),
                          );
                        },
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
                              onPressed: () {
                                // ignore: unused_result
                                // ref.refresh(joinHomeProvider(widget.invite));
                                _handleConfirm();
                              },
                            ),
                          ],
                        ),
                      ),

                SizedBox(height: 12),

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
