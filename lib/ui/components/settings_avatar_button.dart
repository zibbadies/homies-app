import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:homies/providers/user_provider.dart";
import "package:homies/ui/components/h_avatar.dart";

class SettingsAvatarButton extends StatelessWidget {
  const SettingsAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Consumer(
        builder: (context, ref, _) {
          final userAsync = ref.watch(userProvider);
          return userAsync.when(
            data: (user) => GestureDetector(
              onTap: () {
                if (context.mounted) context.push("/settings");
              },
              child: HAvatar(avatar: user.avatar, size: 40),
            ),
            error: (e, _) {
              return Container();
            },
            loading: () => HAvatar(size: 40),
          );
        },
      ),
    );
  }
}
