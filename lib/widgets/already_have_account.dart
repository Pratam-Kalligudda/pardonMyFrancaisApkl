// widgets/already_have_account.dart

import 'package:flutter/material.dart';

class AlreadyHaveAccountRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
          onPressed: () {
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
    );
  }
}
