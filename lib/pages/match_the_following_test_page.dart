// pages/match_the_following_test_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/matching_item_column.dart';

class MatchTheFollowingTestPage extends StatelessWidget {
  final String lessonName;

  const MatchTheFollowingTestPage({Key? key, required this.lessonName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lessonName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Match The Following Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MatchingItemColumn(
                      items: [
                        'Phrase 1',
                        'Phrase 2',
                        // Add more phrases as needed
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: MatchingItemColumn(
                      items: [
                        'Translation 1',
                        'Translation 2',
                        // Add more translations as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}