import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/home_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';
import 'package:homies/ui/components/settings_avatar_button.dart';
import 'package:homies/utils/redirect.dart';

class CreateHomePage extends StatelessWidget {
  const CreateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HTitle(text: "Homies", style: context.texts.titleLarge),
        actions: const [SettingsAvatarButton()],
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colors.surface,
        backgroundColor: context.colors.surface,
        shadowColor: context.colors.onSurface.withValues(alpha: 0.25),
      ),
      backgroundColor: context.colors.surface,
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: CreateHomeForm(),
          ),
        ),
      ),
    );
  }
}

class CreateHomeForm extends ConsumerStatefulWidget {
  const CreateHomeForm({super.key});

  @override
  ConsumerState<CreateHomeForm> createState() => _CreateHomeFormState();
}

class _CreateHomeFormState extends ConsumerState<CreateHomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _homeNameController = TextEditingController();

  bool _submitted = false;

  @override
  void dispose() {
    _homeNameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitted = true;
    });
    ref
        .read(createHomeProvider.notifier)
        .create(_homeNameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final createHomeAsync = ref.watch(createHomeProvider);

    ref.listen(createHomeProvider, (prev, next) {
      final invite = next.valueOrNull;
      if (invite != null && invite.code.isNotEmpty) {
        context.go('/invite_after_create', extra: invite);
        return;
      }
      final error = next.error;
      if (error is ErrorWithCode && error.code == "user_in_house") {
        redirect(context, "/");
      }
    });

    final showLoading = _submitted && createHomeAsync.isLoading;
    final error = _submitted ? createHomeAsync.error : null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HTitle(text: "Create a Home"),

          const SizedBox(height: 12),

          Text(
            "First of all, let's choose a name",
            style: context.texts.displaySmall,
          ),

          const SizedBox(height: 24),

          HLabeledInput(
            label: "Home Name",
            hint: "Gli Splarponi",
            icon: LucideIcons.house,
            controller: _homeNameController,
          ),

          const SizedBox(height: 24),

          if (showLoading)
            HButton(color: context.colors.primary, loading: true)
          else ...[
            if (error is ErrorWithCode) ...[
              Text(
                error.message,
                style: context.texts.titleSmall!.copyWith(
                  color: context.colors.error,
                ),
              ),
              const SizedBox(height: 24),
            ],
            HButton(
              text: error != null ? "Try Again" : "Create",
              color: context.colors.primary,
              onPressed: _handleCreate,
            ),
          ],

          const SizedBox(height: 12),

          HButton(
            text: "Join a Home",
            color: context.colors.secondary,
            textColor: context.colors.onSecondary,
            onPressed: () {
              if (showLoading) return;
              context.push('/join_home');
            },
          ),
        ],
      ),
    );
  }
}
