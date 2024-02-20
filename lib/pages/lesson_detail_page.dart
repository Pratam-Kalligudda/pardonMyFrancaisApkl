// pages/lesson_detail_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/widgets/lesson_detail_tile.dart';

class LessonDetailPage extends StatelessWidget {
  final String lessonName;
  final String levelName;

  const LessonDetailPage({
    Key? key,
    required this.levelName,
    required this.lessonName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Extract lessonName and levelName
    // final lessonName = arguments?['lessonName'] ?? 'Lesson Name';
    final levelName = arguments?['levelName'] ?? 'Level Name';

    return Scaffold(
      appBar: AppBar(
        title: Text(levelName),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, // Remove the shadow
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Handle notifications button press
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              // Handle logout button press
            },
            icon: Icon(Icons.logout),
          ),
        ],
        ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Set the appropriate index for this page
        onTap: (index) {
          if (index == 0) {
            // Navigate to Home Page
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            // Navigate to Profile Page
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$levelName Guide',
                    style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10, // Adjust the number of tiles
                      itemBuilder: (context, index) {
                        return LessonDetailTile(
                          phrase: 'Phrase ${index + 1}',
                          pronunciation: 'Pronunciation ${index + 1}',
                          translation: 'Translation ${index + 1}',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/mcqTest',
                          arguments: {
                            'lessonName': lessonName, // Assuming you want to pass lessonName as well
                            'levelName': levelName,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        child: Text(
                          'Take Test',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
