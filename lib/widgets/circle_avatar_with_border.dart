// widgets/circle_avatar_with_border.dart

import 'package:flutter/material.dart';

/// Widget to display a circular avatar with a border and index number.
class CircleAvatarWithBorder extends StatelessWidget {
  final int index;

  const CircleAvatarWithBorder({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          "$index",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
