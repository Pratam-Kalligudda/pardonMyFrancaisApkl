// widgets/sign_up_button.dart

import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
