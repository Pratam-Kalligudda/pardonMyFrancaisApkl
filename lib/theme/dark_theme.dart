// themes/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color.fromRGBO(0, 255, 227, 1);    
const secondaryColor = Color.fromRGBO(0, 191, 255, 1);   
const backgroundColor = Color.fromRGBO(21, 21, 21, 1); 
const onBackgroundColor = Color.fromRGBO(234, 234, 234, 1);

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,                        
    foregroundColor: Colors.white,                        
    iconTheme: IconThemeData(color: primaryColor),         
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,                      
    unselectedItemColor: Colors.white,                    
    backgroundColor: Colors.black,                       
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,                               
    onPrimary: Colors.grey[900]!,                         
    secondary: secondaryColor,                           
    onSecondary: Colors.grey[200]!,                       
    error: Colors.red,                                   
    onError: Colors.white,                                
    background: backgroundColor,                          
    onBackground: onBackgroundColor,                      
    surface: Colors.grey[800]!,                           
    onSurface: Colors.grey[300]!,                         
  ),
  textTheme: GoogleFonts.latoTextTheme(),         
);