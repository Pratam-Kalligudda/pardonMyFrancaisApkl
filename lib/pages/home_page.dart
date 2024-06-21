import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/models/level.dart';
import 'package:french_app/models/user.dart';
import 'package:french_app/pages/notificatons_page.dart';
import 'package:french_app/providers/user_provider.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/widgets/level_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _startTime;
  int _currentIndex = 0;
  List<Levels> guidebookData = [];

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUserDetails();
    _startSession();
    _fetchData();
  }

  @override
  void dispose() {
    _endSession();
    super.dispose();
  }

  Future<void> _startSession() async {
    _startTime = DateTime.now();
    // print('Session started at $_startTime');
  }

  Future<void> _endSession() async {
    if (_startTime != null) {
      final endTime = DateTime.now();
      final sessionDuration = endTime.difference(_startTime!);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final totalTime = prefs.getInt('total_time') ?? 0;
      final updatedTotalTime = totalTime + sessionDuration.inSeconds;
      await prefs.setInt('total_time', updatedTotalTime);
      // print('Session ended at $endTime');
      // print('Session duration: ${sessionDuration.inSeconds} seconds');
      // print('Total time spent using the app: ${Duration(seconds: updatedTotalTime)}');
    }
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/guidebook'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Levels> levels = jsonData.map((data) => Levels.fromJson(data)).toList();
      setState(() {
        guidebookData = levels;
      });
    } else {
      // print('Failed to load guidebook data: ${response.statusCode}');
      throw Exception('Failed to load levels');
    }
  }

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
        title: const Text(
          'Pardon My Francais',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final User? user = userProvider.user;
          final levelScores = userProvider.levelScores; 
          if (user != null) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(text: "Hi, "),
                          TextSpan(text: user.username,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Date Joined: ${user.registrationDate}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 50),
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
                          double score = levelScores[level.levelName] ?? 0;
                          return LevelTile(
                            name: level.levelName,
                            subName: level.subtitle,
                            index: index + 1,
                            score: score,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
