import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:homies/extensions/theme_extension.dart';
import 'package:homies/ui/components/h_button.dart';

typedef NavItem = ({String url, IconData icon});

final List<NavItem> _items = [
  (url: "/", icon: LucideIcons.house),
  (url: "/todo", icon: LucideIcons.list_todo),
  (url: "/calendar", icon: LucideIcons.calendar),
  (url: "/wallet", icon: LucideIcons.wallet),
];

class HNavBar extends StatelessWidget {
  final int currentIndex;

  const HNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _items.length,
            (index) => HButton(
              icon: _items[index].icon,
              onPressed: () => context.go(_items[index].url),

              width: 80,
              borderRadius: 8,
              shadow: false,

              color: index == currentIndex
                  ? context.colors.primary
                  : context.colors.secondary,
              textColor: index == currentIndex
                  ? context.colors.onPrimary
                  : context.colors.onSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
