// pages/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/providers/sign_up_provider.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/snackbar.dart';
import 'package:french_app/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Consumer<SignUpProvider>(
                  builder: (context, provider, _) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
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
                              textEditingController: _usernameController,
                              hintText: "Username",
                              textInputType: TextInputType.text,
                            ),
                            const SizedBox(height: 12),
                            TextFieldInput(
                              textEditingController: _emailController,
                              hintText: "Email",
                              textInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            TextFieldInput(
                              textEditingController: _passwordController,
                              hintText: "Password",
                              textInputType: TextInputType.text,
                              isPassword: true,
                            ),
                            const SizedBox(height: 60),
                            CustomButton(
                              text: "Sign Up",
                              onPressed: provider.isLoading
                                  ? null
                                  : () {
                                      final username = _usernameController.text.trim();
                                      final email = _emailController.text.trim();
                                      final password = _passwordController.text.trim();

                                      if (username.isEmpty) {
                                        showStyledSnackBar(context, 'Please enter your username.');
                                      } else if (email.isEmpty) {
                                        showStyledSnackBar(context, 'Please enter your email.');
                                      } else if (password.isEmpty) {
                                        showStyledSnackBar(context, 'Please enter your password.');
                                      } else {
                                        provider.signUp(
                                          context,
                                          email,
                                          username,
                                          password,
                                        );
                                      }
                                    },
                              isLoading: provider.isLoading,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                                TextButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : () {
                                          Navigator.pushNamed(context, '/signIn');
                                        },
                                  child: Text(
                                    "Sign In",
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
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
