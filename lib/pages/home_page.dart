// pages/home_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/models/user.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/widgets/level_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Inside the onPressed callback of your logout button/icon
void _logout(BuildContext context) async {
  // Navigate back to the welcome page and clear the navigation stack
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('user');
  Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      // Decode the JSON string back into a User object
      final Map<String, dynamic> userData = jsonDecode(userJson);
      final User user = User.fromJson(userData);
      setState(() {
        _user = user;
      });
    }
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pardon My Francais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add your notifications logic here
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == _currentIndex) {
              // Clicked on the same tab, do nothing or handle accordingly
            } else {
              _currentIndex = index;
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/profile');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/settings');
                  break;
                default:
              }
            }
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Hi, ${_user?.username}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _user?.registrationDate ?? "1 Jan, 2002",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Levels',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              for (int index = 0; index < 10; index++)
                LevelTile(
                  name: 'Level ${index + 1}',
                  subName: 'Subtitle',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
