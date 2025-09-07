import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/home/create_home_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';
import 'package:homies/ui/pages/create_home/invite_after_create_home.dart';

class CreateHomePage extends StatelessWidget {
  const CreateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
  ConsumerState<CreateHomeForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<CreateHomeForm> {
  final _formKey = GlobalKey<FormState>();
  final homeNameController = TextEditingController();

  @override
  void dispose() {
    homeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createHomeState = ref.watch(createHomeProvider);
    final createHomeNotifier = ref.read(createHomeProvider.notifier);

    void handleCreate() {
      if (_formKey.currentState!.validate()) {
        createHomeNotifier.create(homeNameController.text.trim());
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HTitle(text: "Create a Home"),

          SizedBox(height: 12),

          Text(
            "First of all, let's choose a name",
            style: context.texts.displaySmall,
          ),

          SizedBox(height: 24),

          HLabeledInput(
            label: "Home Name",
            hint: "Gli Splarponi",
            icon: LucideIcons.house,
            controller: homeNameController,
          ),

          SizedBox(height: 24),

          createHomeState.when(
            data: (invite) {
              if (invite.invite != "") {
                context.go('/invite_after_create', extra: invite.invite);
              }

              return Column(
                children: [
                  HButton(
                    text: "Create",
                    color: context.colors.primary,
                    onPressed: () => handleCreate(),
                  ),
                ],
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
                    error.toString().replaceFirst(RegExp(r'Exception: '), ''),
                    style: context.texts.titleSmall!.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                HButton(
                  text: "Try Again",
                  color: context.colors.primary,
                  onPressed: () => handleCreate(),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          HButton(
            text: "Join a Home",
            color: context.colors.secondary,
            textColor: context.colors.onSecondary,
            onPressed: () {
              context.go('/join_home');
            },
          ),
        ],
      ),
    );
  }
}
