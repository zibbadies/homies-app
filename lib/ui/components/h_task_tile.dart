import "package:flutter/material.dart";
import 'package:homies/extensions/theme_extension.dart';
import "package:homies/data/models/avatar.dart";
import "package:homies/ui/components/h_avatar.dart";

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

//TODO: fare che quando premi sulle task ti apre la tendina con la task completax e altre info
class _HTaskTileState extends State<HTaskTile> {
  bool _completed = false;

  void toggleComplete() {
    setState(() {
      _completed = !_completed;
    });
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

      child: GestureDetector(
        onTap: () {
          toggleComplete();
          widget.onToggle(_completed);
        },
        child: ListTile(
          horizontalTitleGap: 8,

          contentPadding: const EdgeInsets.only(right: 12, left: 16),
          minVerticalPadding: 0,

          leading: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _completed ? context.colors.primary : Color(0xFFAAAAAA),
                width: 2,
              ),
              color: _completed ? context.colors.primary : Colors.transparent,
            ),
            child: null,
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
          trailing: GestureDetector(
            onTap: () {},
            child: HAvatar(avatar: widget.avatar, size: 36),
          ),
        ),
      ),
    );
  }
}
