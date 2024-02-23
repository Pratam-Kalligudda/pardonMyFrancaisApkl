// pages/sign_in_page.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/snackbar.dart';
import 'package:french_app/widgets/text_field_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

    @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  void _showSignInSnackbar(BuildContext context, String message) {
    showStyledSnackBar(context, message);
  }

  Future<void> _signIn(String username, String password) async {
    setState(() {
      _isLoading = true;
    });

    final Uri url = Uri.parse('http://ec2-44-211-62-237.compute-1.amazonaws.com/api/login');
    final Map<String, String> requestBody = {
      'username': username,
      'password': password,
    };

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];

        // Store token securely
        await _storeToken(token);

        // Navigate to the home screen
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        final String errorMessage = jsonDecode(response.body)['error'];
        _showSignInSnackbar(context, errorMessage);
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      _showSignInSnackbar(context, 'Failed to sign in. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  const TextSpan(text: "Sign in to continue your "),
                  TextSpan(
                    text: "French",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const TextSpan(text: " lessons"),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Username",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(
                  height: 60,
                ),
                CustomButton(
              text: 'Sign In',
              onPressed: () {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                if (username.isEmpty || password.isEmpty) {
                  _showSignInSnackbar(context, 'Please enter username and password');
                } else {
                  _signIn(username, password);
                }
              },
              isLoading: _isLoading,
            ),
                const SizedBox(
                  height: 30,
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
          },
      ),
    ),
    );
  }
}

