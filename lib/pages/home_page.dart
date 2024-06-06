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

class _HomePageState extends State<HomePage> {
  User? _user;
  DateTime? _startTime;
  int _dailyStreak = 1;
  int _currentIndex = 0;
  String? _currentLevel;
  List<Levels> guidebookData = [];

  @override
  void initState() {
    super.initState();
    _startSession();
    _loadUserDetails();
    _fetchData();
    _calculateDailyStreak();
  }

  @override
  void dispose() {
    _endSession();
    super.dispose();
  }

  // Methods related to session management
  Future<void> _startSession() async {
    _startTime = DateTime.now();
    print('Session started at $_startTime');
  }

  Future<void> _endSession() async {
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

  // Method to calculate daily streak
  Future<void> _calculateDailyStreak() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastAccessDate = prefs.getString('last_access_date');
    final currentDate = DateTime.now().toString().split(' ')[0];

    if (lastAccessDate == null || lastAccessDate != currentDate) {
      setState(() {
        _dailyStreak = 1;
      });
      await prefs.setString('last_access_date', currentDate);
    } else {
      setState(() {
        _dailyStreak++;
      });
    }

    print('Daily streak: $_dailyStreak');
  }

  // Method to load user details
  Future<void> _loadUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      final User user = User.fromJson(userData);
      setState(() {
        _user = user;
      });
    }
  }

  // Method to fetch data from the server
  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/guidebook'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Levels> levels = jsonData.map((data) => Levels.fromJson(data)).toList();
      setState(() {
        guidebookData = levels;
      });
    } else {
      print('Failed to load guidebook data: ${response.statusCode}');
      throw Exception('Failed to load levels');
    }
  }

  // Method to set the current level
  void _setCurrentLevel(String levelName) {
    setState(() {
      _currentLevel = levelName;
    });
    print('Current Level: $_currentLevel');
  }

  // Method to log out
  void _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
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
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
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
              if (guidebookData.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: guidebookData.length,
                  itemBuilder: (context, index) {
                    var level = guidebookData[index];
                    return LevelTile(
                      name: level.levelName,
                      subName: level.subtitle,
                      index: index + 1,
                      onTap: () => _setCurrentLevel(level.levelName),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
