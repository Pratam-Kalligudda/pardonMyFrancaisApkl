// pages/home_page.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/models/level.dart';
import 'package:french_app/models/user.dart';
import 'package:french_app/pages/notificatons_page.dart';

import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/widgets/level_tile.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Achievement {
  final String id;
  final String name;
  final String description;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['_id']['\$oid'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

void _logout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('user');
  Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
}

class _HomePageState extends State<HomePage> {
  User? _user;
  List<Levels> guidebookData = [];
  DateTime? _startTime;
  int _dailyStreak = 1;
  List<Achievement> _achievements = [];
  
  @override
  void initState() {
    super.initState();
    loadUserDetails();
    fetchData();
    startSession();
    calculateDailyStreak();
  }

  @override
  void dispose() {
    endSession(); // Call endSession when the widget is disposed
    super.dispose();
  }

  Future<void> startSession() async {
    _startTime = DateTime.now();
    print('Session started at $_startTime');
  }

  Future<void> endSession() async {
    if (_startTime != null) {
      final endTime = DateTime.now();
      final sessionDuration = endTime.difference(_startTime!);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final totalTime = prefs.getInt('total_time') ?? 0;
      final updatedTotalTime = totalTime + sessionDuration.inSeconds;
      await prefs.setInt('total_time', updatedTotalTime);

      print('Session ended at $endTime');
      print('Session duration: ${sessionDuration.inSeconds} seconds');
      print('Total time spent using the app: ${Duration(seconds: updatedTotalTime)}');
    }
  }

  Future<void> calculateDailyStreak() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastAccessDate = prefs.getString('last_access_date');
    final currentDate = DateTime.now().toString().split(' ')[0]; // Get current date in yyyy-MM-dd format

    if (lastAccessDate == null || lastAccessDate != currentDate) {
      // If last access date is null or different from current date, reset streak to 1
      setState(() {
        _dailyStreak = 1;
      });
      await prefs.setString('last_access_date', currentDate); // Update last access date
    } else {
      // Increment streak if accessed on the same day
      setState(() {
        _dailyStreak++;
      });
    }

    print('Daily streak: $_dailyStreak');
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

  Future<List<Levels>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/guidebook'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Levels> levels =
          jsonData.map((data) => Levels.fromJson(data)).toList();
      return levels;
    } else {
      print('Failed to load guidebook data: ${response.statusCode}');
      throw Exception('Failed to load levels');
    }
  }

  int _currentIndex = 0;
  String? _currentLevel;

  void setCurrentLevel(String levelName) {
    setState(() {
      _currentLevel = levelName;
    });
    print('Current Level: $_currentLevel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pardon My Francais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
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
            } else {
              _currentIndex = index;
              switch (index) {
                case 0:
                  // Do nothing as it's the current page
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
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const TextSpan(text: "Hi, "),
                    TextSpan(
                      text: _user?.username,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Date Joined: ${_user?.registrationDate}",
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
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const SizedBox(height: 20),
              FutureBuilder<List<Levels>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Levels> levels = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        var level = levels[index];
                        return LevelTile(
                          name: level.levelName,
                          subName: level.subtitle,
                          index: index + 1,
                          onTap: () => setCurrentLevel(level.levelName),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
