//widgets/levels_list.dart

import 'package:flutter/material.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:provider/provider.dart';
import 'level_tile.dart';

class LevelsList extends StatelessWidget {
  const LevelsList({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final levelScores = progressProvider.levelScores;

    return ListView.builder(
      itemCount: levelScores.length,
      itemBuilder: (context, index) {
        final levelName = levelScores.keys.elementAt(index);
        final score = levelScores[levelName] ?? 0.0;
        return LevelTile(
          name: levelName,
          subName: "Sub Name $index", 
          index: index,
          score: score,
        );
      },
    );
  }
}
