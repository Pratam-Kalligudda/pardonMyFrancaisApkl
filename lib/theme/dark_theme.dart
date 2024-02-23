// themes/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Color.fromRGBO(0, 255, 227, 1)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromRGBO(0, 255, 227, 1), // Set your desired color
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color.fromRGBO(0, 255, 227, 1),
        onPrimary: Colors.grey[900]!,
        secondary: const Color.fromARGB(255, 255, 0, 17),
        onSecondary: Colors.grey[200]!,
        error: Colors.red,
        onError: Colors.white,
        background: const Color.fromRGBO(21, 21, 21, 1),
        onBackground: const Color.fromRGBO(234, 234, 234, 1),
        surface: Colors.grey[800]!,
        onSurface: Colors.grey[300]!),
    textTheme: GoogleFonts.latoTextTheme());
