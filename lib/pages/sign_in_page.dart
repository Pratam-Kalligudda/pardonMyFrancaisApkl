// pages/sign_in_page.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/snackbar.dart';
import 'package:french_app/widgets/text_field_input.dart';
import 'package:french_app/providers/auth_provider.dart'; 

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInPage> {
  String apiUrl = dotenv.env['MY_API_URL']!;
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
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

  Future<void> _signIn(String username, String password, AuthProvider auth) async {
    auth.setLoading(true);

    final Uri url = Uri.parse(
        '$apiUrl/logIn');
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
        final Map<String, dynamic> userData = responseData['userResponse'];
        
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(userData));

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        final String errorMessage = jsonDecode(response.body)['error'];
        _showSignInSnackbar(context, errorMessage);
      }
    } catch (e) {
      _showSignInSnackbar(
          context, 'Failed to sign in. Please try again later.');
    } finally {
      auth.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return Container(
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
                    const SizedBox(height: 30),
                    TextFieldInput(
                      textEditingController: _usernameController,
                      hintText: "Username",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: "Password",
                      textInputType: TextInputType.text,
                      isPassword: true,
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: CustomButton(
                        text: 'Sign In',
                        onPressed: auth.isLoading
                            ? null
                            : () {
                                final username = _usernameController.text.trim();
                                final password = _passwordController.text.trim();
                                if (username.isEmpty) {
                                  _showSignInSnackbar(
                                      context, 'Please enter username');
                                } else if (password.isEmpty) {
                                  _showSignInSnackbar(
                                      context, 'Please enter password');
                                } else {
                                  _signIn(username, password, auth);
                                }
                              },
                        isLoading: auth.isLoading,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        TextButton(
                          onPressed: auth.isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/signUp');
                                },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
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
          );
        },
      ),
    );
  }
}
