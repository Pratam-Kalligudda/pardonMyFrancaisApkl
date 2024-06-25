// providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:french_app/models/user.dart';

class UserProvider with ChangeNotifier {
  // State variable to hold user data
  User? _user;
  // State variable to indicate loading status
  bool _isLoading = false;
  // Variable to hold error messages
  String? _errorMessage;

  // Getter for user data
  User? get user => _user;
  // Getter for loading status
  bool get isLoading => _isLoading;
  // Getter for error message
  String? get errorMessage => _errorMessage;

  // API endpoint for user data
  static const String _userEndpoint = 'http://ec2-3-83-31-77.compute-1.amazonaws.com:8080/api/user';

  // Method to get JWT token from SharedPreferences
  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method to load user details from the API
  Future<void> loadUserDetails() async {
    _setLoading(true);
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        _setErrorMessage('JWT token not found');
        return;
      }

      final response = await http.get(
        Uri.parse(_userEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final User user = User.fromJson(userData);
        _user = user;
        _setErrorMessage(null); // Clear any previous error messages
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

  // Method to update loading status and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to update error message and notify listeners
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
