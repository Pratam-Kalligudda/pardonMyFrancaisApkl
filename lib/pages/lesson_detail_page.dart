// pages/lesson_detail_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/providers/guidebook_provider.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/lesson_detail_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonDetailPage extends StatefulWidget {
  final String lessonName;
  final String levelName;

  const LessonDetailPage({
    Key? key,
    required this.levelName,
    required this.lessonName,
  }) : super(key: key);

  @override
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);
      levelProvider.updateLevelName(widget.levelName);
      levelProvider.fetchGuidebooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.levelName, context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: _buildBody(context, widget.levelName, widget.lessonName),
    );
  }

  AppBar _buildAppBar(String levelName, BuildContext context) {
    return AppBar(
      title: Text(
        levelName,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
    );
  }

  CustomBottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/profile');
        } else {
          Navigator.pushNamed(context, '/settings');
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, String levelName, String lessonName) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLevelGuideText(context),
            const SizedBox(height: 20),
            _buildGuidebookContent(context, lessonName, levelName),
            const SizedBox(height: 5),
            _buildTakeTestButton(context, lessonName, levelName),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelGuideText(BuildContext context) {
    return Center(
      child: Text(
        'Guidebook',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget _buildGuidebookContent(BuildContext context, String lessonName, String levelName) {
    return Expanded(
      child: Consumer<LevelProvider>(
        builder: (context, levelProvider, child) {
          if (levelProvider.levels.isEmpty && levelProvider.errorMessage == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (levelProvider.errorMessage != null) {
            return Center(child: Text('Error: ${levelProvider.errorMessage}'));
          } else {
            return ListView.builder(
              itemCount: levelProvider.levels[0].guidebookContent.length,
              itemBuilder: (context, index) {
                final level = levelProvider.levels[0].guidebookContent[index];
                return LessonDetailTile(
                  phrase: level.frenchWord,
                  pronunciation: level.frenchPronunciation,
                  translation: level.englishTranslation,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildTakeTestButton(BuildContext context, String lessonName, String levelName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final prefs = snapshot.data!;
            final hasTakenTest = prefs.getBool('mcq_test_${lessonName}_$levelName') ?? false;

            return CustomButton(
              text: 'Take Test',
              onPressed: () {
                if (hasTakenTest) {
                  Navigator.pushNamed(
                    context,
                    '/audioVisualTest',
                    arguments: {
                      'lessonName': lessonName,
                      'levelName': levelName,
                    },
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/mcqTest',
                    arguments: {
                      'lessonName': lessonName,
                      'levelName': levelName,
                    },
                  );
                }
              },
              isLoading: false,
            );
          },
        ),
      ),
    );
  }
}
