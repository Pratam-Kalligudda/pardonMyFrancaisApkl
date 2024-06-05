// pages/welcome_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/sign_in_button.dart';
import 'package:french_app/widgets/sign_up_button.dart';
import 'package:french_app/widgets/welcome_page_description.dart';
import 'package:french_app/widgets/welcome_page_title.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  
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
            WelcomeTitle(),
            WelcomeDescription(),
            const SizedBox(height: 120),
            SignUpButton(),
            const SizedBox(height: 30),
            SignInButton(),
          ],
        ),
      ),
    );
  }
}
