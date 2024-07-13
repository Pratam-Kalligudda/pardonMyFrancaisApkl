// providers/sign_up_provider.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:french_app/widgets/snackbar.dart';

class SignUpProvider extends ChangeNotifier {
  String apiUrl = dotenv.env['MY_API_URL']!;
  
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context, String email, String username, String password) async {
    setLoading(true);

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/signUp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        final Map<String, dynamic> userData = responseData['userResponse'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(userData));

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        final String errorMessage = jsonDecode(response.body)['error'];
        showStyledSnackBar(context, errorMessage);
      }
    } catch (error) {
      showStyledSnackBar(context, 'Sign up failed: ${error.toString()}');
    } finally {
      setLoading(false);
    }
  }
}