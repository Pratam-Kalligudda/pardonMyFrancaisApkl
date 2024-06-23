// themes/light_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define colors for the light theme
const primaryColor = Color.fromRGBO(24, 176, 137, 1);     // Green color for primary elements
const secondaryColor = Color.fromRGBO(69, 89, 223, 1);    // Blue color for secondary elements
const backgroundColor = Color.fromRGBO(251, 251, 251, 1); // Light background color
const onBackgroundColor = Color.fromRGBO(21, 21, 21, 1);  // Dark color for text on light background

// Light theme data definition
ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,                        // White app bar background
    foregroundColor: Colors.black,                        // Black app bar text color
    iconTheme: IconThemeData(
      color: Colors.black,                               // Icons in app bar use black color
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,                      // Selected item in bottom nav bar uses primary color
    unselectedItemColor: Colors.black,                    // Unselected items in bottom nav bar use black color
    backgroundColor: Colors.white,                        // White background for bottom nav bar
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,                                // Primary color used throughout the app
    onPrimary: Colors.grey[100]!,                         // Text color on primary color
    secondary: secondaryColor,                            // Secondary color used for other UI elements
    onSecondary: Colors.grey[100]!,                       // Text color on secondary color
    error: Colors.red,                                    // Error color
    onError: Colors.white,                                // Text color on error color
    background: backgroundColor,                          // Background color
    onBackground: onBackgroundColor,                      // Text color on background color
    surface: Colors.grey[300]!,                           // Surface color (e.g., cards, dialogs)
    onSurface: Colors.grey[800]!,                         // Text color on surface color
  ),
  textTheme: GoogleFonts.latoTextTheme(),                 // Use Google Fonts Lato for text styling
);
