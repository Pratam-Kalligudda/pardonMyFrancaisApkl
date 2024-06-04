// pages/welcome_page.dart

import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final navigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());


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
            const SizedBox(
              height: 24,
            ),
            Text(
              "A simple, fun, and creative way of learing and becoming fluent in french.",
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 120,
            ),
            OutlinedButton(
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
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}