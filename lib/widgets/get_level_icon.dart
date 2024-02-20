// widgets/get_level_icon.dart

import 'package:flutter/material.dart';

class LevelIcon extends StatelessWidget {
  final int index;

  const LevelIcon({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of icons corresponding to level numbers
    final List<IconData> levelIcons = [
      Icons.looks_one,
      Icons.looks_two,
      Icons.looks_3,
      Icons.looks_4,
      Icons.looks_5,
      Icons.looks_6
      // ... add more icons as needed
    ];

    // Make sure the index is within the valid range
    final int iconIndex = index % levelIcons.length;

    return Icon(
      levelIcons[iconIndex],
      color: Theme.of(context).colorScheme.primary,
      size: 28,
    );
  }
}
