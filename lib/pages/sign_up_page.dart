// pages/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/already_have_account.dart';
import 'package:french_app/widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
            SignUpForm(),
            const SizedBox(height: 30),
            AlreadyHaveAccountRow(),
          ],
        ),
      ),
    );
  }
}
