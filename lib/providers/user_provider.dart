import 'package:flutter/material.dart';
import 'package:french_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> loadUserDetails() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final User user = User.fromJson(userData);
        _user = user;
        notifyListeners();
      } else if (response.statusCode == 404) {
        print('User profile not found');
      } else {
        print('Failed to load user profile data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading user profile data: $error');
    }
  }
}
