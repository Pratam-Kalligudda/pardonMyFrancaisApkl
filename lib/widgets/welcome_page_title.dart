// widgets/welcome_page_title.dart

import 'package:flutter/material.dart';

class WelcomeTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
