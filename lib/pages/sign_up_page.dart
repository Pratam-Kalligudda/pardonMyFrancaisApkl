// pages/sign_up_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/text_field_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> signup(String username, String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://ec2-44-211-62-237.compute-1.amazonaws.com/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];
      final Map<String, dynamic> userData = responseData['user'];

      // Save token and user details to shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode(userData));
      String userd = prefs.getString('user')!;
      String tokend = prefs.getString('token')!;
      print('User:  $userd');
      print('Token: $tokend');
      setState(() {
        _isLoading = false;
      });

      // Navigate to the home screen or perform other actions
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      // Handle errors
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  const TextSpan(text: "Sign up now to access immersive "),
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
              textEditingController: _emailController,
              hintText: "Email",
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
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
              isPass: true,
            ),
            const SizedBox(height: 60),
            CustomButton(
              text: "Sign Up",
              onPressed: () {
                if (_detailsAreNotEntered(_usernameController, _emailController, _passwordController)) {
                  _showSignUpSnackbar(context);
                  return; // Return to prevent further execution
                }
                // Proceed with signup process
                signup(_usernameController.text, _emailController.text, _passwordController.text);
              },
              isLoading: _isLoading,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/signIn');
                        },
                  child: Text(
                    "Sign In",
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
        ),
      ),
    );
  }
}

bool _detailsAreNotEntered(TextEditingController usernameController, TextEditingController emailController, TextEditingController passwordController) {
  return usernameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty;
}

void _showSignUpSnackbar(BuildContext context) {
  const snackBar = SnackBar(
    content: Text('Please enter your username, email, and password to sign up.'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}