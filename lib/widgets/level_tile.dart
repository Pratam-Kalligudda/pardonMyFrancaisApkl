// widgets/level_tile.dart

import 'package:flutter/material.dart';
import 'package:french_app/providers/guidebook_provider.dart';
import 'package:provider/provider.dart';

class LevelTile extends StatelessWidget {
  final String name;
  final String subName;
  final int index;

  const LevelTile({
    Key? key,
    required this.name,
    required this.subName,
    required this.index,
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
              'lessonName':
                  subName,
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 3),
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
                    ),
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Text(
                      subName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
