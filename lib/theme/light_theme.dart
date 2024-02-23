// themes/light_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(251, 251, 251, 1),
      iconTheme: IconThemeData(
        color: Color.fromRGBO(21, 21, 21, 1),
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromRGBO(24, 176, 137, 1), // Set your desired color
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
    ),
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromRGBO(24, 176, 137, 1),
      onPrimary: Colors.grey[100]!,
      secondary: const Color.fromRGBO(69, 89, 223, 1),
      onSecondary: Colors.grey[100]!,
      error: Colors.red,
      onError: Colors.white,
      background: const Color.fromRGBO(251, 251, 251, 1),
      onBackground: const Color.fromRGBO(21, 21, 21, 1),
      surface: Colors.grey[300]!,
      onSurface: Colors.grey[800]!),
  textTheme: GoogleFonts.latoTextTheme(),
);
