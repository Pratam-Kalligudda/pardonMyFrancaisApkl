//pages/home_page.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:french_app/models/level.dart';
import 'package:french_app/models/user.dart';
import 'package:french_app/pages/notificatons_page.dart';
import 'package:french_app/providers/progress_provider.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  String apiUrl = dotenv.env['MY_API_URL']!;
  int _currentIndex = 0;
  List<Levels> guidebookData = [];

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() => _loadUserData());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchData();
      Provider.of<ProgressProvider>(context, listen: false).loadUserProgress();
    }
  }

  Future<void> _loadUserData() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserDetails();
    await Provider.of<ProgressProvider>(context, listen: false).loadUserProgress();
  }
  
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/guidebook'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Levels> levels = jsonData.map((data) => Levels.fromJson(data)).toList();
        setState(() {
          guidebookData = levels;
        });
      } else {
        throw Exception('Failed to load levels');
      }
    } catch (error) {
      setState(() {
      });
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
      appBar: _buildAppBar(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onBottomNavigationTap(index, context),
      ),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Pardon My Francais',
        style: TextStyle(
          fontSize: 18,
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
    );
  }

  Widget _buildBody(BuildContext context) {
     return Consumer2<UserProvider, ProgressProvider>(
      builder: (context, userProvider, progressProvider, child) {
        final user = userProvider.user;
        final levelScores = progressProvider.levelScores;

        if (userProvider.isLoading || progressProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (user != null) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildGreeting(user),
                  const SizedBox(height: 50),
                  Text(
                    'Levels',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 20),
                  if (guidebookData.isEmpty)
                    const Center(child: Text('No levels available.'))
                  else
                    _buildLevelTiles(guidebookData, levelScores),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildGreeting(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            children: [
              const TextSpan(text: "Hi, "),
              TextSpan(
                text: user.username,
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
            fontSize: 14,
          ),
        ),
      ],
    );
  }


  Widget _buildLevelTiles(List<Levels> guidebookData, Map<String, double> levelScores) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: guidebookData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 1),
      itemBuilder: (context, index) {
        var level = guidebookData[index];
        double score = levelScores[(index + 1).toString()] ?? 0;
        return LevelTile(
          name: level.levelName,
          subName: level.subtitle,
          index: index + 1,
          score: score,
        );
      },
    );
  }

  void _onBottomNavigationTap(int index, BuildContext context) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      switch (index) {
        case 0:
          // Do nothing as it's the current page
          break;
        case 1:
          Navigator.popAndPushNamed(context, '/profile');
          break;
        case 2:
          Navigator.popAndPushNamed(context, '/settings');
          break;
        default:
      }
    }
  }
}