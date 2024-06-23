// providers/guidebook_provider.dart

import 'package:flutter/material.dart';
import 'package:french_app/models/level.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider with ChangeNotifier {
  List<Levels> _levels = [];
  String? _errorMessage;
  late String _levelName;

  String get levelName => _levelName;

  void updateLevelName(String newLevelName) {
    _levelName = newLevelName;
    notifyListeners();
  }

  List<Levels> get levels => _levels;
  String? get errorMessage => _errorMessage;

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchGuidebooks() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        _errorMessage = 'JWT token not found';
        notifyListeners();
        return;
      }

      String encodedLevelName = Uri.encodeComponent(levelName);
      final response = await http.get(
        Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/guidebook/$encodedLevelName'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        _levels = jsonResponse.map((json) => Levels.fromJson(json)).toList();
        _errorMessage = null; // Reset error message on success
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load guidebooks';
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      notifyListeners();
    }
  }
}