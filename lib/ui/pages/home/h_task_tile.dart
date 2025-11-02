import 'package:flutter/material.dart';
import 'package:homies/data/models/avatar.dart';
import 'package:homies/ui/pages/home/home_page.dart';

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

