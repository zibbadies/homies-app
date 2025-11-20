import "package:flutter/material.dart";
import 'package:homies/extensions/theme_extension.dart';
import "package:homies/data/models/avatar.dart";
import "package:homies/ui/components/h_avatar.dart";
import "package:homies/ui/components/h_button.dart";

class HTaskTile extends StatefulWidget {
  final String text;
  final Avatar avatar;
  final void Function(bool) onToggle;

  const HTaskTile({
    super.key,
    required this.text,
    required this.avatar,
    required this.onToggle,
  });

  @override
  State<HTaskTile> createState() => _HTaskTileState();
}

class _HTaskTileState extends State<HTaskTile> {
  bool _completed = false;

  void toggleComplete() {
    setState(() {
      _completed = !_completed;
    });
  }

  void showInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      barrierColor: context.colors.onSurface.withAlpha(120),
      builder: (context) {
        // Local state for the modal (mirrors the parent)
        bool localCompleted = _completed;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return InfoModal(
              text: widget.text,
              completed: localCompleted,

              onToggle: () {
                // Update the modal UI
                setModalState(() => localCompleted = !localCompleted);

                // Update parent widget
                toggleComplete();

                // If you want to close after toggle:
                // Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: ListTile(
        onTap: () {
          showInfo();
          widget.onToggle(_completed);
        },
        horizontalTitleGap: 8,

        contentPadding: const EdgeInsets.only(right: 12),
        minVerticalPadding: 0,

        leading: GestureDetector(
          onTap: () {
            toggleComplete();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            // This ensures the tap area is as tall as the ListTile
            height: double.infinity,
            width: 40, // Width of the tap target (adjust as needed)
            alignment: Alignment.center,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _completed
                      ? context.colors.primary
                      : Color(0xFFAAAAAA),
                  width: 2,
                ),
                color: _completed ? context.colors.primary : Colors.transparent,
              ),
              child: null,
            ),
          ),
        ),
        title: Text(
          widget.text,

          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.texts.bodyLarge!.copyWith(
            decoration: _completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: context.colors.onSurface.withValues(alpha: 0.5),
            color: _completed
                ? context.colors.onSurface.withValues(alpha: 0.5)
                : context.colors.onSurface,
          ),
        ),
        trailing: HAvatar(avatar: widget.avatar, size: 36),
      ),
    );
  }
}

class InfoModal extends StatelessWidget {
  const InfoModal({
    super.key,
    required this.text,
    required this.completed,
    required this.onToggle,
  });

  final String text;
  final bool completed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Task's Details",
                style: context.texts.headlineMedium,
                textAlign: TextAlign.left,
              ),

              SizedBox(height: 12),

              Text(text, style: context.texts.bodyLarge),

              SizedBox(height: 48),

              HButton(
                text: completed ? "Mark as Incomplete" : "Complete Task",
                onPressed: onToggle,
                color: completed
                    ? context.colors.secondary
                    : context.colors.primary,
                textColor: completed
                    ? context.colors.onSecondary
                    : context.colors.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
