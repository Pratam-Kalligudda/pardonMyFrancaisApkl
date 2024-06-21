import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProgressProvider with ChangeNotifier {
  Map<String, dynamic> _userProgress = {};

  Map<String, dynamic> get userProgress {
    return _userProgress;
  }

  bool _isLoading = false;
  int _currentLevel = 0;
  int _totalLevelsCompleted = 0;
  int _streak = 0;
  int _highestCombo = 0;
  int _pointsEarned = 0;
  String _lastLessonDate = '';

  bool get isLoading => _isLoading;
  int get currentLevel => _currentLevel;
  int get totalLevelsCompleted => _totalLevelsCompleted;
  int get streak => _streak;
  int get highestCombo => _highestCombo;
  int get pointsEarned => _pointsEarned;
  String get lastLessonDate => _lastLessonDate;

  Future<void> loadUserProgress() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/getUserProgress'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _currentLevel = jsonData['currentLevel'];
      _totalLevelsCompleted = jsonData['totalLevelsCompleted'];
      _streak = jsonData['streak'];
      _highestCombo = jsonData['highestCombo'];
      _pointsEarned = jsonData['pointsEarned'];
      _lastLessonDate = jsonData['lastLessonDate'];
    } else {
      throw Exception('Failed to load user progress');
    }

    _isLoading = false;
    notifyListeners();
  }
}