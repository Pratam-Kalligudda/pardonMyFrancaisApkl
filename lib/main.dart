// main.dart

import 'package:flutter/material.dart';
import 'package:french_app/pages/account_settings_page.dart';
import 'package:french_app/pages/audio_visual_test_page.dart';
import 'package:french_app/pages/notification_setttings_page.dart';
import 'package:french_app/pages/notificatons_page.dart';
import 'package:french_app/pages/settings_page.dart';
import 'package:french_app/pages/sign_in_page.dart';
import 'package:french_app/pages/sign_up_page.dart';
import 'package:french_app/pages/home_page.dart';
import 'package:french_app/pages/lesson_detail_page.dart';
import 'package:french_app/pages/mcq_test_page.dart';
import 'package:french_app/pages/profile_page.dart';
import 'package:french_app/pages/welcome_page.dart';
import 'package:french_app/providers/auth_provider.dart';
import 'package:french_app/providers/guidebook_provider.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/providers/sign_up_provider.dart';
import 'package:french_app/providers/theme_provider.dart';
import 'package:french_app/providers/user_provider.dart';
import 'package:french_app/theme/dark_theme.dart';
import 'package:french_app/theme/light_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Your App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const WelcomePage(),
              '/signIn': (context) => const SignInPage(),
              '/signUp': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
              '/profile': (context) => ProfilePage(),
              '/notifications': (context) => const NotificationsPage(),
              '/settings': (context) => const SettingsPage(),
              '/accountsettings': (context) => const AccountSettingsPage(),
              '/notificationsettings': (context) => const NotificationsSettingsPage(),
              '/lessonDetail': (context) => const LessonDetailPage(lessonName: '', levelName: ''),
              '/mcqTest': (context) => const MCQTestPage(lessonName: '', levelName: ''),
              '/audiovisual': (context) => AudioVisualTestPage(lessonName: '', levelName: ''),
            },
          );
        },
      ),
    );
  }
}