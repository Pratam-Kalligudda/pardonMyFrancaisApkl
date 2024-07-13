//pages/welcome_page.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderText(context),
            const SizedBox(height: 24),
            _buildDescriptionText(context),
            const SizedBox(height: 120),
            _buildSignUpButton(context),
            const SizedBox(height: 30),
            _buildSignInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Join a community of enthusiasts to learn ",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        Text(
          "French",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return Text(
      "A simple, fun, and creative way of learning and becoming fluent in French.",
      style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.onBackground),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signUp');
      },
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Center(
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signIn');
      },
      style: ElevatedButton.styleFrom(
        elevation: 12,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Center(
          child: Text(
            "Sign In",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
