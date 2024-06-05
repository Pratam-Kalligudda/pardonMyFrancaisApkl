// widgets/welcome_page_description.dart

import 'package:flutter/material.dart';

class WelcomeDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "A simple, fun, and creative way of learing and becoming fluent in french.",
      style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.onBackground),
    );
  }
}
