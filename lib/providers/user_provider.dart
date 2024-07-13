// providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:french_app/models/user.dart';

class UserProvider with ChangeNotifier {
  String apiUrl = dotenv.env['MY_API_URL']!;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> loadUserDetails() async {
    _setLoading(true);
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        _setErrorMessage('JWT token not found');
        return;
      }

      final response = await http.get(
        Uri.parse('$apiUrl/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final User user = User.fromJson(userData);
        _user = user;
        _setErrorMessage(null);
      } else if (response.statusCode == 404) {
        _setErrorMessage('User profile not found');
      } else {
        _setErrorMessage('Failed to load user profile data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      _setErrorMessage('Error loading user profile data: $error');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}