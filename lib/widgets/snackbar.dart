// widgets/snackbar.dart

import 'package:flutter/material.dart';

void showStyledSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
