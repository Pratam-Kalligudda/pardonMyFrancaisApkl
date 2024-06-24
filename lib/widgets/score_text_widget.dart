// widgets/score_text_widget.dart

import 'package:flutter/material.dart';

/// Widget to display a score text.
class ScoreTextWidget extends StatelessWidget {
  final double score;

  const ScoreTextWidget({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        score.toStringAsFixed(4),
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
