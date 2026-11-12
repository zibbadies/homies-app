import "package:flutter/material.dart";
import "package:flutter_lucide/flutter_lucide.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:homies/data/models/error.dart';
import 'package:homies/extensions/theme_extension.dart';
import "package:homies/data/models/avatar.dart";
import "package:homies/providers/lists_provider.dart";
import "package:homies/ui/components/h_avatar.dart";
import "package:homies/ui/components/h_button.dart";

void showTaskError(BuildContext context, Object e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e is ErrorWithCode ? e.message : 'Something went wrong'),
    ),
  );
}

class HTaskTile extends ConsumerWidget {
  final String id;
  final String text;
  final bool completed;
  final Avatar? avatar;

  const HTaskTile({
    super.key,
    required this.id,
    required this.text,
    required this.completed,
    this.avatar,
  });

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(todoListProvider.notifier).markItemAs(!completed, id);
    } catch (e) {
      if (context.mounted) showTaskError(context, e);
    }
  }

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      barrierColor: context.colors.onSurface.withAlpha(120),
      builder: (_) => TaskSheet(id: id, text: text, completed: completed),
    ).then((_) => FocusManager.instance.primaryFocus?.unfocus());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        onTap: () => _showInfo(context),
        horizontalTitleGap: 8,

        contentPadding: const EdgeInsets.only(right: 12),
        minVerticalPadding: 0,

        leading: GestureDetector(
          onTap: () => _toggle(context, ref),
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
                  color: completed
                      ? context.colors.primary
                      : const Color(0xFFAAAAAA),
                  width: 2,
                ),
                color: completed ? context.colors.primary : Colors.transparent,
              ),
              child: null,
            ),
          ),
        ),
        title: Text(
          text,

          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.texts.bodyLarge!.copyWith(
            decoration: completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationColor: context.colors.onSurface.withValues(alpha: 0.5),
            color: completed
                ? context.colors.onSurface.withValues(alpha: 0.5)
                : context.colors.onSurface,
          ),
        ),
        trailing: HAvatar(avatar: avatar, size: 36),
      ),
    );
  }
}

/// Bottom sheet for a single task: details, edit and delete-confirmation
/// views are managed as internal state of this one sheet.
class TaskSheet extends ConsumerStatefulWidget {
  const TaskSheet({
    super.key,
    required this.id,
    required this.text,
    required this.completed,
  });

  final String id;
  final String text;
  final bool completed;

  @override
  ConsumerState<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends ConsumerState<TaskSheet> {
  bool _editing = false;
  bool _confirmingDelete = false;
  late bool _completed = widget.completed;
  late String _text = widget.text;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    setState(() => _completed = !_completed);
    try {
      await ref
          .read(todoListProvider.notifier)
          .markItemAs(_completed, widget.id);
    } catch (e) {
      if (!mounted) return;
      setState(() => _completed = !_completed);
      showTaskError(context, e);
    }
  }

  void _startEdit() {
    _controller.text = _text;
    setState(() => _editing = true);
  }

  Future<void> _saveEdit() async {
    final newText = _controller.text;
    setState(() {
      _text = newText;
      _editing = false;
    });
    try {
      await ref.read(todoListProvider.notifier).editItem(newText, widget.id);
    } catch (e) {
      if (mounted) showTaskError(context, e);
    }
  }

  Future<void> _delete() async {
    try {
      await ref.read(todoListProvider.notifier).deleteItem(widget.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showTaskError(context, e);
    }
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
            child: _confirmingDelete ? _buildDeleteConfirm() : _buildInfo(),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          _editing ? "Editing Task" : "Task's Details",
          style: context.texts.headlineSmall,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 12),

        _editing
            ? TextField(
                autofocus: true,
                controller: _controller,
                style: context.texts.bodyLarge,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write something...",
                  hintStyle: context.texts.bodyLarge!.copyWith(
                    color: context.colors.onSecondary.withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              )
            : Text(_text, style: context.texts.bodyLarge),

        const SizedBox(height: 48),

        Row(
          children: [
            if (_editing) ...[
              Expanded(
                child: HButton(
                  text: "Cancel",
                  onPressed: () => setState(() => _editing = false),
                  color: context.colors.secondary,
                  textColor: context.colors.onSecondary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: HButton(
                  text: "Edit",
                  onPressed: _saveEdit,
                  color: context.colors.primary,
                  textColor: context.colors.onPrimary,
                ),
              ),
            ],
            if (!_editing) ...[
              HButton(
                icon: LucideIcons.trash,
                onPressed: () => setState(() => _confirmingDelete = true),
                width: 48,
                color: context.colors.secondary,
                textColor: context.colors.onSecondary,
              ),

              const SizedBox(width: 12),

              HButton(
                icon: LucideIcons.square_pen,
                onPressed: _startEdit,
                width: 48,
                color: context.colors.secondary,
                textColor: context.colors.onSecondary,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: HButton(
                  text: _completed ? "Mark as Incomplete" : "Complete Task",
                  onPressed: _toggle,
                  color: _completed
                      ? context.colors.secondary
                      : context.colors.primary,
                  textColor: _completed
                      ? context.colors.onSecondary
                      : context.colors.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDeleteConfirm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Deleting Task",
          style: context.texts.headlineSmall,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 12),

        Text(
          "This could be permanent, or it could be not. Who knows.",
          style: context.texts.bodyLarge,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: HButton(
                text: "Delete",
                color: context.colors.error,
                textColor: context.colors.onError,
                onPressed: _delete,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: HButton(
                text: "Cancel",
                color: context.colors.secondary,
                textColor: context.colors.onSecondary,
                onPressed: () => setState(() => _confirmingDelete = false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
