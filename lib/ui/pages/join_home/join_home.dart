import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_button.dart';
import 'package:homies/ui/components/h_title.dart';
import 'package:homies/ui/components/h_labeled_input.dart';

class JoinHomePage extends StatelessWidget {
  const JoinHomePage({super.key});

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
            child: JoinHomeForm(),
          ),
        ),
      ),
    );
  }
}

class JoinHomeForm extends ConsumerStatefulWidget {
  const JoinHomeForm({super.key});

  @override
  ConsumerState<JoinHomeForm> createState() => _JoinHomeFormState();
}

class _JoinHomeFormState extends ConsumerState<JoinHomeForm> {
  final _formKey = GlobalKey<FormState>();
  final inviteCodeController = TextEditingController();

  @override
  void dispose() {
    inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleJoin() {
      if (_formKey.currentState!.validate()) {
        // TODO
      }
    }

    return PopScope(
      canPop: true, // TODO: is loading
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HTitle(text: "Insert the\nInvite Code"),

            SizedBox(height: 12),

            Text(
              "You can ask it to your friend",
              style: context.texts.displaySmall,
            ),

            SizedBox(height: 24),

            HLabeledInput(
              label: "Invite Code",
              hint: "XXXXXX",
              icon: LucideIcons.house,
              controller: inviteCodeController,
            ),

            SizedBox(height: 24),

            HButton(
              text: "Join",
              color: context.colors.primary,
              onPressed: () => handleJoin(),
            ),

            SizedBox(height: 12),

            HButton(
              text: "Create a New Home",
              color: context.colors.secondary,
              textColor: context.colors.onSecondary,
              onPressed: () {
                // you can be in this page only if u were in /create_home previously

                // TODO: add isLoading check on joinState
                if (mounted && Navigator.canPop(context)) {
                  context.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
