import 'package:flutter/material.dart';
import 'package:french_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  final Map<String, double> _levelScores = {};

  Map<String, double> get levelScores => _levelScores;

  void updateLevelScore(String levelName, double score) {
    _levelScores[levelName] = score;
    notifyListeners();
  }

  Future<void> loadUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      final User user = User.fromJson(userData);
      _user = user;
      notifyListeners(); // Call notifyListeners here
    }
  }
}