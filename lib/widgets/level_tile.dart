// widgets/level_tile.dart

import 'package:flutter/material.dart';
import 'package:french_app/providers/guidebook_provider.dart';
import 'package:provider/provider.dart';
import 'circle_avatar_with_border.dart';

class LevelTile extends StatelessWidget {
  final String name;
  final String subName;
  final int index;
  final double score;

  const LevelTile({
    Key? key,
    required this.name,
    required this.subName,
    required this.index,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () {
          Provider.of<LevelProvider>(context, listen: false)
              .updateLevelName(name);
          Navigator.pushNamed(
            context,
            '/lessonDetail',
            arguments: {
              'lessonName': subName,
              'levelName': name,
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatarWithBorder(index: index),
              const SizedBox(width: 7),
              VerticalDivider(color: Theme.of(context).colorScheme.onSurface),
              Expanded(
                child: Text(
                  subName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              VerticalDivider(color: Theme.of(context).colorScheme.onSurface),
              Text(
                  "score: ${score.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
