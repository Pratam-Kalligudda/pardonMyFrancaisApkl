// main.dart

import 'package:flutter/material.dart';
import 'package:french_app/pages/audio_visual_test_page.dart';
import 'package:french_app/pages/sign_in_page.dart';
import 'package:french_app/pages/sign_up_page.dart';
import 'package:french_app/pages/home_page.dart';
import 'package:french_app/pages/lesson_detail_page.dart';
import 'package:french_app/pages/mcq_test_page.dart';
import 'package:french_app/pages/profile_page.dart';
import 'package:french_app/pages/welcome_page.dart';
import 'package:french_app/providers/guidebook_provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => LevelProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your App',
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/audiovisual',
        routes: {
          '/': (context) => const WelcomePage(),
          '/signIn': (context) => const SignInPage(),
          '/signUp': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/lessonDetail': (context) =>
              const LessonDetailPage(lessonName: '', levelName: ''),
          '/mcqTest': (context) => const MCQTestPage(
                lessonName: '',
                levelName: '',
              ),
          '/profile': (context) => const ProfilePage(),
          // '/notifications': (context) => const NotificationsPage(),
          '/audiovisual': (context) => const AudioVideoPage(),
        },
      ),
    );
  }
}
