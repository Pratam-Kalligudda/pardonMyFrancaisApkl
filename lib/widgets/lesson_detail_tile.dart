// widgets/lesson_detail_tile.dart

import 'package:flutter/material.dart';

class LessonDetailTile extends StatelessWidget {
  final String phrase;
  final String pronunciation;
  final String translation;

  const LessonDetailTile({
    Key? key,
    required this.phrase,
    required this.pronunciation,
    required this.translation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(phrase, FontWeight.bold, 20, context),
            const SizedBox(height: 8),
            _buildText('Pronunciation: $pronunciation', FontWeight.normal, 16, context),
            const SizedBox(height: 4),
            _buildText('Translation: $translation', FontWeight.normal, 16, context),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, FontWeight fontWeight, double fontSize, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
