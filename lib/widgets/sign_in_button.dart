// widgets/sign_in_button.dart

import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
