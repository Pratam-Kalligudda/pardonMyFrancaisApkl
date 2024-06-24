// providers/guidebook_provider.dart

import 'package:flutter/material.dart';
import 'package:french_app/models/level.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider with ChangeNotifier {
  // List to hold levels
  List<Levels> _levels = [];
  // Variable to hold error messages
  String? _errorMessage;
  // Variable to hold the name of the current level
  late String _levelName;

  // Getter for level name
  String get levelName => _levelName;

  // Method to update level name and notify listeners
  void updateLevelName(String newLevelName) {
    _levelName = newLevelName;
    notifyListeners();
  }

  // Getter for levels
  List<Levels> get levels => _levels;
  // Getter for error message
  String? get errorMessage => _errorMessage;

  // API base URL
  static const String _apiBaseUrl = 'http://ec2-3-83-31-77.compute-1.amazonaws.com:8080/api/guidebook';

  // Method to get JWT token from SharedPreferences
  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to fetch guidebooks from the API
  Future<void> fetchGuidebooks() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        _errorMessage = 'JWT token not found';
        notifyListeners();
        return;
      }

      final String encodedLevelName = Uri.encodeComponent(levelName);
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/$encodedLevelName'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        _levels = jsonResponse.map((json) => Levels.fromJson(json)).toList();
        _errorMessage = null; // Reset error message on success
      } else {
        _errorMessage = 'Failed to load guidebooks (${response.statusCode})';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      notifyListeners(); // Ensure listeners are always notified
    }
  }
}
