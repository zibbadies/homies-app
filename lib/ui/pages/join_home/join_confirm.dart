import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/home_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';

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

                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: inviteInfo.members.length,
                          itemBuilder: (context, index) => Text(
                            inviteInfo.members[index].name,
                            style: context.texts.displaySmall,
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stack) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/join_home', extra: widget.invite);
                    });

                    return Text("error");
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
                              context.go('/');
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
                        error: (error, stack) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (error.toString().isNotEmpty) ...[
                              Text(
                                error.toString(),
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
                                ref.refresh(joinHomeProvider(widget.invite));
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
