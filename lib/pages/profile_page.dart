import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/widgets/snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isNameEditing = false;
  bool _isBioEditing = false;
  bool _isLocationEditing = false;

  final _formKey = GlobalKey<FormState>();

  String? _selectedAvatar;

  final List<String> _avatars = [
    'assets/avatars/1.png',
    'assets/avatars/2.png',
    'assets/avatars/3.png',
    'assets/avatars/4.png',
    'assets/avatars/5.png',
    'assets/avatars/6.png',
    'assets/avatars/7.png',
  ];

  final Map<String, String> _achievementImages = {
    'Novice Learner': 'assets/achievements/bronze_medal.png',
    'Dedicated Learner': 'assets/achievements/silver_medal.png',
    'Master Learner': 'assets/achievements/gold_medal.png',
    'Streak Beginner': 'assets/achievements/bronze_ribbon.png',
    'Streak Pro': 'assets/achievements/silver_ribbon.png',
    'Streak Champion': 'assets/achievements/gold_ribbon.png',
    'Point Collector': 'assets/achievements/trophy.png',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserDetails();
    Provider.of<ProgressProvider>(context, listen: false).loadUserProgress();
  }

  Future<void> _loadUserDetails() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        _nameController.text = userData['name'] ?? '';
        _bioController.text = userData['bio'] ?? '';
        _locationController.text = userData['location'] ?? '';
        if (userData['profilePhoto'] != null) {
          _selectedAvatar = 'assets/avatars/${userData['profilePhoto']}.png';
        } else {
          _selectedAvatar = null;
        }
      } else if (response.statusCode == 404) {
        showStyledSnackBar(context, 'User profile not found');
      } else {
        showStyledSnackBar(context, 'Failed to load user profile data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      showStyledSnackBar(context, 'Error loading user profile data: $error');
    }
  }

  Future<void> _updateProfile() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080/api/updateProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(<String, dynamic>{
          'updates': [
            {'field': 'name', 'value': _nameController.text},
            {'field': 'bio', 'value': _bioController.text},
            {'field': 'location', 'value': _locationController.text},
            if (_selectedAvatar != null) {'field': 'profilePhoto', 'value': _selectedAvatar!.split('/').last.split('.').first},
          ]
        }),
      );

      if (response.statusCode == 200) {
        showStyledSnackBar(context, 'Profile updated successfully');
      } else {
        showStyledSnackBar(context, 'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      showStyledSnackBar(context, 'Error updating profile: $error');
      rethrow;
    }
  }

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveChanges() async {
    setState(() {});

    await _updateProfile();

    setState(() {
      _isNameEditing = false;
      _isBioEditing = false;
      _isLocationEditing = false;
    });
  }

  Widget _buildProgressList(ProgressProvider progressData) {
    if (progressData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressListItem('Current Level', progressData.currentLevel.toString()),
            _buildProgressListItem('Total Levels Completed', progressData.totalLevelsCompleted.toString()),
            _buildProgressListItem('Streak', progressData.streak.toString()),
            _buildProgressListItem('Points Earned', progressData.pointsEarned.toString()),
            _buildProgressListItem('Highest Combo', progressData.highestCombo.toString()),
            _buildProgressListItem('Last Lesson Date', progressData.lastLessonDate),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Level Scores',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ..._buildLevelScores(progressData.levelScores),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Achievements',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ..._buildAchievements(progressData.achievements),
          ],
        ),
      );
    }
  }

  List<Widget> _buildLevelScores(Map<String, double> levelScores) {
    return levelScores.entries.map((entry) {
      return ListTile(
        title: Text('Level ${entry.key}'),
        trailing: Text('${entry.value.toStringAsFixed(2)} points'),
      );
    }).toList();
  }

  List<Widget> _buildAchievements(List<String> achievements) {
    return achievements.map((achievement) {
      return ListTile(
        leading: _achievementImages.containsKey(achievement)
          ? Image.asset(
              _achievementImages[achievement]!,
              width: 40,
              height: 40,
            )
          : null,
        title: Text(achievement),
      );
    }).toList();
  }

  Widget _buildProgressListItem(String title, String value) {
    return ListTile(
      title: Text(title),
      trailing: Text(value),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // Current page
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length < 2) {
      return 'Field must be at least 2 characters long';
    }
    return null;
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData iconData,
    bool isFieldEditing,
    String? Function(String?) validator,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isFieldEditing) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Continued from previous code snippet...

                return AlertDialog(
                  title: Text(
                    'Edit $label',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  content: TextFormField(
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    validator: validator,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          onPressed();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Text(
            controller.text,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1, // Set the current index to ProfilePage index
          onTap: _onBottomNavTap,
        ),
        body: Consumer<ProgressProvider>(
          builder: (context, progressData, _) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedAvatar != null
                              ? AssetImage(_selectedAvatar!)
                              : const AssetImage('assets/icons/profile.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.onPrimary,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Select Avatar'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          children: List.generate(_avatars.length, (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedAvatar = _avatars[index];
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  _avatars[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                    'Name',
                    _nameController,
                    Icons.person_outline,
                    _isNameEditing,
                    _validateName,
                    () async {
                      if (!_isNameEditing && (_formKey.currentState?.validate() ?? false)) {
                        await _saveChanges();
                      }
                      setState(() {
                        _isNameEditing = !_isNameEditing;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                    'Bio',
                    _bioController,
                    Icons.info_outline,
                    _isBioEditing,
                    _validateField,
                    () async {
                      if (!_isBioEditing && (_formKey.currentState?.validate() ?? false)) {
                        await _saveChanges();
                      }
                      setState(() {
                        _isBioEditing = !_isBioEditing;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                    'Location',
                    _locationController,
                    Icons.location_on_outlined,
                    _isLocationEditing,
                    _validateField,
                    () async {
                      if (!_isLocationEditing && (_formKey.currentState?.validate() ?? false)) {
                        await _saveChanges();
                      }
                      setState(() {
                        _isLocationEditing = !_isLocationEditing;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildProgressList(progressData),
                ],
              ),
            );
          },
        ),
      );
    }
  }