import "package:flutter/material.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:homies/extensions/theme_extension.dart';
import "package:homies/data/models/avatar.dart";
import "package:homies/providers/lists_provider.dart";
import "package:homies/ui/components/h_avatar.dart";
import "package:homies/ui/components/h_button.dart";

class HTaskTile extends StatefulWidget {
  final String id;
  final String text;
  final Avatar? avatar;
  final void Function(bool) onToggle;

  const HTaskTile({
    super.key,
    required this.id,
    required this.text,
    this.avatar,
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
              id: widget.id,
              text: widget.text,
              completed: localCompleted,

              onToggle: () {
                // Update the modal UI
                setModalState(() => localCompleted = !localCompleted);
                toggleComplete();
              },
              onDelete: () {
                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 50), () {
                  showModalBottomSheet(
                    context: this.context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    backgroundColor: context.colors.surface,
                    builder: (_) => DeleteConfirmModal(
                      onCancel: () {
                        Navigator.pop(this.context);
                        showInfo();
                      },
                    ),
                  );
                });
              },
            );
          },
        );
      },
    ).then((_) => FocusManager.instance.primaryFocus?.unfocus());
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
          // widget.onToggle(_completed); TODO: i don't know why this was here
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
            height: double.infinity,
            width: 40,
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

class InfoModal extends ConsumerStatefulWidget {
  const InfoModal({
    super.key,
    required this.id,
    required this.text,
    required this.completed,
    required this.onToggle,
    required this.onDelete,
  });

  final String id;
  final String text;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  ConsumerState<InfoModal> createState() => _InfoModalState();
}

class _InfoModalState extends ConsumerState<InfoModal> {
  bool _editing = false;
  String _text = "";
  final controller = TextEditingController();

  void toggleEdit() {
    setState(() {
      _editing = !_editing;
    });
    if (_editing) controller.text = _text;
  }

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    controller.text = _text;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  _editing ? "Editing Task" : "Task's Details",
                  style: context.texts.headlineSmall,
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 12),

                _editing
                    ? TextField(
                        autofocus: true,
                        controller: controller,
                        style: context.texts.bodyLarge,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Write something...",
                          hintStyle: context.texts.bodyLarge!.copyWith(
                            color: context.colors.onSecondary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      )
                    : Text(_text, style: context.texts.bodyLarge),

                SizedBox(height: 48),

                Row(
                  children: [
                    if (_editing) ...[
                      Expanded(
                        child: HButton(
                          text: "Cancel",
                          onPressed: toggleEdit,
                          color: context.colors.secondary,
                          textColor: context.colors.onSecondary,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: HButton(
                          text: "Edit",
                          onPressed: () {
                            ref
                                .read(todoListProvider.notifier)
                                .editItem(controller.text, widget.id);
                            setState(() => _text = controller.text);
                            toggleEdit();
                          },
                          color: context.colors.primary,
                          textColor: context.colors.onPrimary,
                        ),
                      ),
                    ],
                    if (!_editing) ...[
                      HButton(
                        icon: LucideIcons.trash,
                        onPressed: widget.onDelete,
                        width: 48,
                        color: context.colors.secondary,
                        textColor: context.colors.onSecondary,
                      ),

                      SizedBox(width: 12),

                      HButton(
                        icon: LucideIcons.square_pen,
                        onPressed: toggleEdit,
                        width: 48,
                        color: context.colors.secondary,
                        textColor: context.colors.onSecondary,
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: HButton(
                          text: widget.completed
                              ? "Mark as Incomplete"
                              : "Complete Task",
                          onPressed: widget.onToggle,
                          color: widget.completed
                              ? context.colors.secondary
                              : context.colors.primary,
                          textColor: widget.completed
                              ? context.colors.onSecondary
                              : context.colors.onPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteConfirmModal extends StatelessWidget {
  const DeleteConfirmModal({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Deleting Task",
                  style: context.texts.headlineSmall,
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 12),

                Text(
                  "This could be permanent, or it could be not. Who knows.",
                  style: context.texts.bodyLarge,
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: HButton(
                        text: "Delete",
                        color: context.colors.error,
                        textColor: context.colors.onError,
                        onPressed: () {},
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: HButton(
                        text: "Cancel",
                        color: context.colors.secondary,
                        textColor: context.colors.onSecondary,
                        onPressed: onCancel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
