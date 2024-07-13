// widgets/snackbar.dart

import 'package:flutter/material.dart';

void showStyledSnackBar(BuildContext context, String text, {TextStyle? textStyle}) {
  final defaultTextStyle = TextStyle(
    fontSize: 12,
    color: Theme.of(context).colorScheme.onError,
  );

  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: textStyle ?? defaultTextStyle,
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.error,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}