import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/home_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';

class JoinHomePage extends StatelessWidget {
  const JoinHomePage({super.key, this.invite});

  final Invite? invite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        actions: const [SettingsAvatarButton()],
        automaticallyImplyLeading: false,
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
            child: JoinHomeForm(invite: invite),
          ),
        ),
      ),
    );
  }
}

class JoinHomeForm extends ConsumerStatefulWidget {
  const JoinHomeForm({super.key, this.invite});

  final Invite? invite;

  @override
  ConsumerState<JoinHomeForm> createState() => _JoinHomeFormState();
}

class _JoinHomeFormState extends ConsumerState<JoinHomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeController = TextEditingController();

  Invite? _invite;

  @override
  void initState() {
    super.initState();
    _invite = widget.invite;

    if (_invite?.code.isNotEmpty == true) {
      _inviteCodeController.text = _invite!.code;
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _handleGetInviteInfo() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _invite = Invite(code: _inviteCodeController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final invite = _invite;
    final inviteInfoAsync = invite != null
        ? ref.watch(inviteInfoProvider(invite))
        : null;

    if (invite != null) {
      ref.listen(inviteInfoProvider(invite), (prev, next) {
        if (next.hasValue) {
          // .go (not .push) so this page — and the autoDispose family
          // instance it watches — are disposed on navigation.
          context.go('/join_confirm', extra: invite);
        }
      });
    }

    return PopScope(
      canPop: inviteInfoAsync == null || !inviteInfoAsync.isLoading,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HTitle(text: "Insert the\nInvite Code"),

            const SizedBox(height: 12),

            Text(
              "You can ask it to your friend",
              style: context.texts.displaySmall,
            ),

            const SizedBox(height: 24),

            HLabeledInput(
              label: "Invite Code",
              hint: "XXXXXX",
              icon: LucideIcons.house,
              controller: _inviteCodeController,
              // TODO: add personalized keebType
            ),

            const SizedBox(height: 24),

            if (inviteInfoAsync == null)
              HButton(
                text: "Join",
                color: context.colors.primary,
                onPressed: _handleGetInviteInfo,
              )
            else
              inviteInfoAsync.when(
                data: (_) => HButton(
                  text: "Join",
                  color: context.colors.primary,
                  onPressed: _handleGetInviteInfo,
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
                      onPressed: _handleGetInviteInfo,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            HButton(
              text: "Create a New Home",
              color: context.colors.secondary,
              textColor: context.colors.onSecondary,
              onPressed: () {
                if (inviteInfoAsync != null && inviteInfoAsync.isLoading) {
                  return;
                }
                if (Navigator.canPop(context)) return context.pop();
                context.go("/create_home");
              },
            ),
          ],
        ),
      ),
    );
  }
}
