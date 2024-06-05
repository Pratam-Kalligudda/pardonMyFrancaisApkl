// widgets/sign_up_form.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/text_field_input.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Column(
      children: [
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
            // Handle sign-up process
          },
          isLoading: false, // Provide a value for isLoading
        ),
      ],
    );
  }
}
