// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:french_app/widgets/slide_up_page_route.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(create: (_) => ThemeProvider(context)),
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
            onGenerateRoute: (settings) {
              final args = settings.arguments as Map<String, dynamic>?;

              switch (settings.name) {
                case '/':
                  return SlideUpPageRoute(page: const WelcomePage());
                case '/signIn':
                  return SlideUpPageRoute(page: const SignInPage());
                case '/signUp':
                  return SlideUpPageRoute(page: const SignUpPage());
                case '/home':
                  return SlideUpPageRoute(page: const HomePage());
                case '/profile':
                  return SlideUpPageRoute(page: const ProfilePage());
                case '/notifications':
                  return SlideUpPageRoute(page: const NotificationsPage());
                case '/settings':
                  return SlideUpPageRoute(page: const SettingsPage());
                case '/accountsettings':
                  return SlideUpPageRoute(page: const AccountSettingsPage());
                case '/notificationsettings':
                  return SlideUpPageRoute(page: const NotificationsSettingsPage());
                case '/lessonDetail':
                  return SlideUpPageRoute(
                    page: LessonDetailPage(
                      lessonName: args?['lessonName'] ?? '',
                      levelName: args?['levelName'] ?? '',
                    ),
                  );
                case '/mcqTest':
                  return SlideUpPageRoute(
                    page: MCQTestPage(
                      lessonName: args?['lessonName'] ?? '',
                      levelName: args?['levelName'] ?? '',
                    ),
                  );
                case '/audiovisual':
                  return SlideUpPageRoute(
                    page: AudioVisualTestPage(
                      lessonName: args?['lessonName'] ?? '',
                      levelName: args?['levelName'] ?? '',
                    ),
                  );
                default:
                  return MaterialPageRoute(builder: (context) => const WelcomePage());
              }
            },
          );
        },
      ),
    );
  }
}