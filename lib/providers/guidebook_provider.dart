// providers/guidebook_provider.dart

import 'package:flutter/material.dart';
import 'package:french_app/models/level.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider with ChangeNotifier {
  List<Levels> _levels = [];
  late String _levelName;
  Map<String, bool> _mcqProgress = {};
  Map<String, bool> _pronunciationProgress = {};

  String get levelName => _levelName;

  void updateLevelName(String newLevelName) {
    _levelName = newLevelName;
    notifyListeners(); // Notify listeners about the change
  }

  List<Levels> get levels => _levels;
  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchGuidebooks() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }
      String encodedLevelName = Uri.encodeComponent(levelName);
      final response = await http.get(
        Uri.parse(
            'http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/guidebook/$encodedLevelName'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        _levels = jsonResponse.map((json) => Levels.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load guidebooks');
      }
    } catch (error) {
      rethrow;
    }
  }
  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mcqProgress = (prefs.getString('mcqProgress') != null)
        ? Map<String, bool>.from(json.decode(prefs.getString('mcqProgress')!))
        : {};
    _pronunciationProgress = (prefs.getString('pronunciationProgress') != null)
        ? Map<String, bool>.from(json.decode(prefs.getString('pronunciationProgress')!))
        : {};
  }

  Future<void> _saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mcqProgress', json.encode(_mcqProgress));
    prefs.setString('pronunciationProgress', json.encode(_pronunciationProgress));
  }

  void updateMcqProgress(String levelName, bool completed) {
    _mcqProgress[levelName] = completed;
    _saveProgress();
    notifyListeners();
  }

  void updatePronunciationProgress(String levelName, bool completed) {
    _pronunciationProgress[levelName] = completed;
    _saveProgress();
    notifyListeners();
  }

  bool isMcqCompleted(String levelName) {
    return _mcqProgress[levelName] ?? false;
  }

  bool isPronunciationCompleted(String levelName) {
    return _pronunciationProgress[levelName] ?? false;
  }
}
