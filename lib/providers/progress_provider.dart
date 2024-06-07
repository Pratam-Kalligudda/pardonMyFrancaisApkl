import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  // String userId = '';
  int currentLevel = 0;
  Map<String, dynamic> levelScores = {};
  // int totalTimeSpent = 0;
  int streak = 0;
  int pointsEarned = 0;
  List<String> achievements = [];
  int currentCombo = 0;
  int highestCombo = 0;
  String lastLessonDate = '';
  int totalLevelsCompleted = 0;

  void updateProgressData(Map<String, dynamic> data) {
    // userId = data['user_id'];
    currentLevel = data['level_progress']['current_level'];
    levelScores = data['level_progress']['level_scores'];
    // totalTimeSpent = data['total_time_spent'];
    streak = data['streak'];
    pointsEarned = data['points_earned'];
    achievements = List<String>.from(data['achievements']);
    currentCombo = data['current_combo'];
    highestCombo = data['highest_combo'];
    lastLessonDate = data['last_lesson_date'];
    totalLevelsCompleted = data['total_levels_completed'];
    notifyListeners();
  }
}
