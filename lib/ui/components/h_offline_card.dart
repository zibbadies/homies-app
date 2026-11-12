import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:homies/extensions/theme_extension.dart';

/// Red error card shown at the top of a page (just under the app bar) when
/// the device is offline or the page data couldn't be loaded.
/// Follows the app's card language: rounded borders + soft shadow.
/// The page decides when to show it and with which message.
class HOfflineCard extends StatelessWidget {
  const HOfflineCard({
    super.key,
    required this.message,
    this.icon = LucideIcons.wifi_off,
    this.onRetry,
  });

  /// App error red, as per design.
  static const Color errorBackground = Color(0xFFE94D4D);

  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: context.texts.titleSmall!.copyWith(color: Colors.white),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  LucideIcons.rotate_cw,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
