// providers/progress_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProgressProvider with ChangeNotifier {
  // Map to hold user progress data
  final Map<String, dynamic> _userProgress = {};

  // Getter for user progress data
  Map<String, dynamic> get userProgress => _userProgress;

  // State variable to indicate loading status
  bool _isLoading = false;

  // Getter for loading status
  bool get isLoading => _isLoading;

  // Method to update loading status and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to update user progress data and notify listeners
  void _updateUserProgress({
    required int currentLevel,
    required int totalLevelsCompleted,
    required int streak,
    required int highestCombo,
    required int pointsEarned,
    required String lastLessonDate,
  }) {
    _currentLevel = currentLevel;
    _totalLevelsCompleted = totalLevelsCompleted;
    _streak = streak;
    _highestCombo = highestCombo;
    _pointsEarned = pointsEarned;
    _lastLessonDate = lastLessonDate;
    notifyListeners();
  }

  // Variables to hold user progress details
  int _currentLevel = 0;
  int get currentLevel => _currentLevel;

  int _totalLevelsCompleted = 0;
  int get totalLevelsCompleted => _totalLevelsCompleted;

  int _streak = 0;
  int get streak => _streak;

  int _highestCombo = 0;
  int get highestCombo => _highestCombo;

  int _pointsEarned = 0;
  int get pointsEarned => _pointsEarned;

  String _lastLessonDate = '';
  String get lastLessonDate => _lastLessonDate;

  // Method to load user progress from the API
  Future<void> loadUserProgress() async {
    _setLoading(true);

    try {
      final response = await http.get(
        Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080 /api/getUserProgress'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _updateUserProgress(
          currentLevel: jsonData['currentLevel'],
          totalLevelsCompleted: jsonData['totalLevelsCompleted'],
          streak: jsonData['streak'],
          highestCombo: jsonData['highestCombo'],
          pointsEarned: jsonData['pointsEarned'],
          lastLessonDate: jsonData['lastLessonDate'],
        );
      } else {
        throw Exception('Failed to load user progress (${response.statusCode})');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    } finally {
      _setLoading(false);
    }
  }
}
