// themes/light_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color.fromRGBO(24, 176, 137, 1);     
const secondaryColor = Color.fromRGBO(69, 89, 223, 1);    
const backgroundColor = Color.fromRGBO(251, 251, 251, 1); 
const onBackgroundColor = Color.fromRGBO(21, 21, 21, 1);  

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,                       
    foregroundColor: Colors.black,                       
    iconTheme: IconThemeData(
      color: Colors.black,                               
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,                      
    unselectedItemColor: Colors.black,                   
    backgroundColor: Colors.white,                        
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,                                
    onPrimary: Colors.grey[100]!,                         
    secondary: secondaryColor,                            
    onSecondary: Colors.grey[100]!,                       
    error: Colors.red,                                    
    onError: Colors.white,                               
    background: backgroundColor,                  
    onBackground: onBackgroundColor,                     
    surface: Colors.grey[300]!,                         
    onSurface: Colors.grey[800]!,                       
  ),
  textTheme: GoogleFonts.latoTextTheme(),                
);
