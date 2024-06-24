// providers/progress_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    required Map<String, double> levelScores,
    required List<String> achievements,
  }) {
    _userProgress['currentLevel'] = currentLevel;
    _userProgress['totalLevelsCompleted'] = totalLevelsCompleted;
    _userProgress['streak'] = streak;
    _userProgress['highestCombo'] = highestCombo;
    _userProgress['pointsEarned'] = pointsEarned;
    _userProgress['lastLessonDate'] = lastLessonDate;
    _userProgress['levelScores'] = levelScores;
    _userProgress['achievements'] = achievements;
    notifyListeners(); // Notify listeners after updating data
  }

  // Variables to hold user progress details
  int get currentLevel => _userProgress['currentLevel'] ?? 0;
  int get totalLevelsCompleted => _userProgress['totalLevelsCompleted'] ?? 0;
  int get streak => _userProgress['streak'] ?? 0;
  int get highestCombo => _userProgress['highestCombo'] ?? 0;
  int get pointsEarned => _userProgress['pointsEarned'] ?? 0;
  String get lastLessonDate => _userProgress['lastLessonDate'] ?? '';
  Map<String, double> get levelScores => _userProgress['levelScores'] ?? {};
  List<String> get achievements => _userProgress['achievements'] ?? [];

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to load user progress from the API
  Future<void> loadUserProgress() async {
    _setLoading(true);

    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080/api/getUserProgress'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Extract and update user progress data
        _userProgress['currentLevel'] = jsonData['level_progress']['current_level'] ?? 0;
        _userProgress['totalLevelsCompleted'] = jsonData['total_levels_completed'] ?? 0;
        _userProgress['streak'] = jsonData['streak'] ?? 0;
        _userProgress['highestCombo'] = jsonData['highest_combo'] ?? 0;
        _userProgress['pointsEarned'] = jsonData['points_earned'] ?? 0;
        _userProgress['lastLessonDate'] = jsonData['last_lesson_date'] ?? '';
        _userProgress['levelScores'] = Map<String, double>.from(_parseLevelScores(jsonData['level_progress']['level_scores'] ?? {}));
        _userProgress['achievements'] = List<String>.from(jsonData['achievements'] ?? []);

        notifyListeners();
      } else {
        print('Response body: ${response.body}');
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load user progress (${response.statusCode})');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    } finally {
      _setLoading(false);
    }
  }

  Map<String, double> _parseLevelScores(Map<String, dynamic> levelScoresJson) {
    Map<String, double> levelScores = {};
    levelScoresJson.forEach((key, value) {
      levelScores[key] = value.toDouble();
    });
    return levelScores;
  }
}
