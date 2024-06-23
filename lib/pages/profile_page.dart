import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/providers/progress_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _userProgress = {};

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isNameEditing = false;
  bool _isBioEditing = false;
  bool _isLocationEditing = false;
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    _loadData();
    Provider.of<ProgressProvider>(context, listen: false).loadUserProgress();
  }

  Future<void> _loadData() async {
    await _loadUserDetails();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final response = await http.get(Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080 /api/getUserProgress'));

    if (response.statusCode == 200) {
      setState(() {
        _userProgress = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load user progress');
    }
  }

  Future<void> _loadUserDetails() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080 /api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        setState(() {
          _nameController.text = userData['name'];
          _bioController.text = userData['bio'];
          _locationController.text = userData['location'];
        });
      } else if (response.statusCode == 404) {
        print('User profile not found for username');
      } else {
        print('Failed to load user profile data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading user profile data: $error');
    }
  }

  Future<void> _updateProfile() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('http://ec2-3-83-31-77.compute-1.amazonaws.com:8080 /api/updateProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(<String, dynamic>{
          'updates': [
            {'field': 'name', 'value': _nameController.text},
            {'field': 'bio', 'value': _bioController.text},
            {'field': 'location', 'value': _locationController.text},
          ]
        }),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
      rethrow;
    }
  }

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    await _updateProfile();

    setState(() {
      _isLoading = false;
      _isNameEditing = false;
      _isBioEditing = false;
      _isLocationEditing = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final progressData = Provider.of<ProgressProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
        style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 30),
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
                  Divider(),
                  Center(
                    child: Text(
                      'User Progress',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProgressList(progressData),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: _selectedAvatar != null
              ? AssetImage(_selectedAvatar!)
                : const AssetImage('assets/icons/profile.png') as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: _avatars.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAvatar = _avatars[index];
                              });
                              Navigator.of(context).pop();
                            },
                            child: Image.asset(_avatars[index]),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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
              return AlertDialog(
                title: Text('Edit $label',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                content: TextFormField(
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                    
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
                    onPressed: () {
                      if (validator(controller.text) == null) {
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

  Widget _buildProgressList(ProgressProvider progressData) {
    if (progressData.isLoading) {
    return Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        // Group 1: Level Progress
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Level Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current Level'),
                    Text('${progressData.userProgress['currentLevel']}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Levels Completed'),
                    Text('${progressData.userProgress['totalLevelsCompleted']}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Group 2: Streak and Combo
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Streak and Combo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Streak'),
                    Text('${progressData.userProgress['streak']}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Highest Combo'),
                    Text('${progressData.userProgress['highestCombo']}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Group 3: Scores and Points
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Scores and Points',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Level Scores'),
                    Text('${progressData.userProgress['levelScores']}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Points Earned'),
                    Text('${progressData.userProgress['pointsEarned']}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Group 4: Achievements
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Achievements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Achievements: ${progressData.userProgress['achievements'].join(', ')}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        // Group 5: Last Lesson Date
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Last Lesson Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Last Lesson Date: ${progressData.userProgress['lastLessonDate']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
}