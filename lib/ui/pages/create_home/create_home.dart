import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/providers/home_provider.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';

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
  ConsumerState<CreateHomeForm> createState() => _CreateHomeFormState();
}

class _CreateHomeFormState extends ConsumerState<CreateHomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _homeNameController = TextEditingController();

  String? _homeName;

  @override
  void dispose() {
    _homeNameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _homeName = _homeNameController.text.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Invite>? createHomeAsync = _homeName != null
        ? ref.watch(createHomeProvider(_homeName!))
        : null;

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
            controller: _homeNameController,
          ),

          SizedBox(height: 24),

          createHomeAsync == null
              ? HButton(
                  text: "Create",
                  color: context.colors.primary,
                  onPressed: () => _handleCreate(),
                )
              : createHomeAsync.when(
                  data: (invite) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (invite.code.isNotEmpty) {
                        context.go('/invite_after_create', extra: invite);
                      }
                    });

                    return HButton(
                      text: "Create",
                      color: context.colors.primary,
                      onPressed: () => _handleCreate(),
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
                        onPressed: () => _handleCreate(),
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
              if (createHomeAsync != null && createHomeAsync.isLoading) return;
              context.push('/join_home');
            },
          ),
        ],
      ),
    );
  }
}
