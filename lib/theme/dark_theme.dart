// themes/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define colors for the dark theme
// ignore: prefer_const_constructors
final primaryColor = Color.fromRGBO(0, 255, 227, 1);      // Cyan color for primary elements
const secondaryColor = Color.fromRGBO(0, 191, 255, 1);    // Lighter cyan color for secondary elements
const backgroundColor = Color.fromRGBO(21, 21, 21, 1);    // Dark background color
const onBackgroundColor = Color.fromRGBO(234, 234, 234, 1); // Light color for text on dark background

// Dark theme data definition
ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,                        // Black app bar background
    foregroundColor: Colors.white,                        // White app bar text color
    iconTheme: IconThemeData(color: primaryColor),         // Icons in app bar use primary color
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,                      // Selected item in bottom nav bar uses primary color
    unselectedItemColor: Colors.white,                    // Unselected items in bottom nav bar use white color
    backgroundColor: Colors.black,                        // Black background for bottom nav bar
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,                                // Primary color used throughout the app
    onPrimary: Colors.grey[900]!,                         // Text color on primary color
    secondary: secondaryColor,                            // Secondary color used for other UI elements
    onSecondary: Colors.grey[200]!,                       // Text color on secondary color
    error: Colors.red,                                    // Error color
    onError: Colors.white,                                // Text color on error color
    background: backgroundColor,                          // Background color
    onBackground: onBackgroundColor,                      // Text color on background color
    surface: Colors.grey[800]!,                           // Surface color (e.g., cards, dialogs)
    onSurface: Colors.grey[300]!,                         // Text color on surface color
  ),
  textTheme: GoogleFonts.latoTextTheme(),                 // Use Google Fonts Lato for text styling
);
