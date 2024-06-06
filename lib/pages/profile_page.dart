import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/pages/notificatons_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final int _completedLessons = 2;
  int _stars = 1;
  int _totalCoins = 1;

  // final TextEditingController _nameController =
  //     TextEditingController(text: 'John Doe');
  // final TextEditingController _emailController =
  //     TextEditingController(text: 'johndoe@example.com');
  // final TextEditingController _bioController =
  //     TextEditingController(text: 'Software Engineer');
  // final TextEditingController _locationController =
  //     TextEditingController(text: 'New York, USA');

  bool _isNameEditing = false;
  // bool _isEmailEditing = false;
  bool _isBioEditing = false;
  bool _isLocationEditing = false;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  final _formKey = GlobalKey<FormState>();

  late List<Map<String, String>> _achievements;



  List<Map<String, String>> _initializeAchievements() {
    return [
    {
      'title': 'Lesson 1 Completed',
      'description': 'Completed lesson 1',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 2 Completed',
      'description': 'Completed lesson 2',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 3 Completed',
      'description': 'Completed lesson 3',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 4 Completed',
      'description': 'Completed lesson 4',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 5 Completed',
      'description': 'Completed lesson 5',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 6 Completed',
      'description': 'Completed lesson 6',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 7 Completed',
      'description': 'Completed lesson 7',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 8 Completed',
      'description': 'Completed lesson 8',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 9 Completed',
      'description': 'Completed lesson 9',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Lesson 10 Completed',
      'description': 'Completed lesson 10',
      'icon': 'assets/icons/badge.png',
    },
    {
      'title': 'Trophy',
      'description': 'Completed all 10 lessons',
      'icon': 'assets/icons/trophy.png',
    },
  ];
  }

  @override
  void initState() {
    super.initState();
    _achievements = _initializeAchievements();
    _loadData();
  }

Future<void> _loadData() async {
  await _loadStars();
  await _loadTotalCoins();
  await _loadUserDetails();
  // _displayAchievements(_completedLessons);
}

Future<void> _loadUserDetails() async {
  try {
    final jwtToken = await _getJwtToken();
    if (jwtToken == null) {
      throw Exception('JWT token not found');
    }

    // final username = await _getCurrentUsername(); // Await the username retrieval

    final response = await http.get(
      Uri.parse('http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/user'),
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

// Future<String?> _getCurrentUsername() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? username = prefs.getString('username');
//   if (username == null || username.isEmpty) {
//     throw Exception('Username not found in SharedPreferences');
//   }
//   return username;
// }


// void _displayAchievements(int completedLessons) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return _buildAchievementsDialog(completedLessons);
//     },
//   );
// }

Future<void> _loadTotalCoins() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? totalCoins = prefs.getInt('totalCoins');
  if (totalCoins != null) {
    setState(() {
      _totalCoins = totalCoins;
    });
  } else {
    _awardCoins(); // Calculate coins if not already stored
  }
}

void _awardCoins() {
  // Award coins for completed lessons
  _totalCoins += (_completedLessons * 500);

  // Award coins for each star increase
  _totalCoins += ((_stars - 1) * 100);

  // Check for additional star milestones
  if (_stars >= 7) {
    _totalCoins += 200; // Award 200 coins for reaching 7 stars
  }
  if (_stars >= 14) {
    _totalCoins += 300; // Award 300 coins for reaching 14 stars
  }

  // Save total coins to SharedPreferences
  _saveTotalCoins();
}

Future<void> _saveTotalCoins() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('totalCoins', _totalCoins);
}

  Future<void> _loadStars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDate = prefs.getString('lastDate');
    int? lastStars = prefs.getInt('stars');

    if (lastDate != null && lastStars != null) {
      DateTime now = DateTime.now();
      DateTime lastDateTime = DateTime.parse(lastDate);

      if (now.day == lastDateTime.day &&
          now.month == lastDateTime.month &&
          now.year == lastDateTime.year) {
        _stars = lastStars;
      } else {
        int daysDifference = now.difference(lastDateTime).inDays;
        // Adjust star count based on daysDifference
        if (daysDifference == 1) {
          _updateStars(); // Increment stars if accessed daily
        } else {
          _resetStars(); // Reset stars if missed a day
        }
      }
    } else {
      _stars = 1;
    }
  }

  Future<void> _updateStars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    int? lastStars = prefs.getInt('stars');
    if (lastStars != null) {
      prefs.setString('lastDate', now.toString());
      prefs.setInt('stars', lastStars + 1); // Increment stars by one
      setState(() {
        _stars = lastStars + 1;
      });
      // Award coins when stars are updated
      _awardCoins();
    }
  }

  Future<void> _resetStars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    prefs.setString('lastDate', now.toString());
    prefs.setInt('stars', 1); // Reset stars to 1
    setState(() {
      _stars = 1;
    });
    // Award coins when stars are reset
    _awardCoins();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      final CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: selectedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _profileImage = XFile(croppedImage.path);
        });
      }
    }
  }

  Future<void> _updateProfile() async {
  try {
    final jwtToken = await _getJwtToken();
    if (jwtToken == null) {
      throw Exception('JWT token not found');
    }

    final response = await http.post(
      Uri.parse('http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/updateProfile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken', // Include JWT token in the request headers
      },
      body: jsonEncode(<String, dynamic>{
        'updates': [
          {'field': 'name', 'value': _nameController.text},
          {'field': 'bio', 'value': _bioController.text},
          {'field': 'location', 'value': _locationController.text},
          // Add other fields as needed
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated profile
      // You can show a success message or handle it as needed
      print('Profile updated successfully');
    } else {
      // Failed to update profile
      // You can show an error message or handle it as needed
      print('Failed to update profile. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Handle network errors or other exceptions
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

    // Save changes to the backend
    await _updateProfile();

    setState(() {
      _isLoading = false;
      _isNameEditing = false;
      // _isEmailEditing = false;
      _isBioEditing = false;
      _isLocationEditing = false;
    });
  }

  void _handleNotificationsPress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsPage()),
    );
  }

  void _logout(BuildContext context) async {
    // Navigate back to the welcome page and clear the navigation stack
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
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

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Email cannot be empty';
  //   }
  //   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  //   if (!emailRegex.hasMatch(value)) {
  //     return 'Enter a valid email';
  //   }
  //   return null;
  // }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _handleNotificationsPress,
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
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
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : const AssetImage('assets/icons/profile.png')
                                  as ImageProvider,
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
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.photo_library),
                                            title: const Text('Gallery'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickImage(ImageSource.gallery);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo_camera),
                                            title: const Text('Camera'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickImage(ImageSource.camera);
                                            },
                                          ),
                                        ],
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
                  const SizedBox(height: 30),
                   _buildEditableField('Name', _nameController, Icons.person_outline, () async {
                    if (!_isNameEditing && (_formKey.currentState?.validate() ?? false)) {
                      await _saveChanges();
                    }
                    setState(() {
                      _isNameEditing = !_isNameEditing;
                    });
                  }, _isNameEditing, _validateName),
                  const SizedBox(height: 20),
                  _buildEditableField('Bio', _bioController, Icons.info_outline, () async {
                    if (!_isBioEditing && (_formKey.currentState?.validate() ?? false)) {
                      await _saveChanges();
                    }
                    setState(() {
                      _isBioEditing = !_isBioEditing;
                    });
                  }, _isBioEditing, _validateField),
                  const SizedBox(height: 20),
                  _buildEditableField('Location', _locationController, Icons.location_on_outlined, () async {
                    if (!_isLocationEditing && (_formKey.currentState?.validate() ?? false)) {
                      await _saveChanges();
                    }
                    setState(() {
                      _isLocationEditing = !_isLocationEditing;
                    });
                  }, _isLocationEditing, _validateField),
                  const SizedBox(height: 20),
                  // _buildEditableField('Email', _emailController, Icons.email_outlined, () async {
                  //   if (!_isEmailEditing && (_formKey.currentState?.validate() ?? false)) {
                  //     await _saveChanges();
                  //   }
                  //   setState(() {
                  //     _isEmailEditing = !_isEmailEditing;
                  //   });
                  // }, _isEmailEditing, _validateEmail),
                  // const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Divider(),
                  _buildStars(),
                  _buildTotalCoins(), 
                  const SizedBox(height: 20),
                  Divider(),
                  Center(
                    child: Text(
                      'Achievements',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildAchievementsGrid(_completedLessons), // Add this line to display total coins
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
              // Do nothing as it's the current page
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }


  Widget _buildEditableField(String label, TextEditingController controller, IconData iconData, VoidCallback onPressed, bool isFieldEditing, String? Function(String?) validator) {
    return GestureDetector(
      onTap: () {
        if (!isFieldEditing) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Edit $label'),
                content: TextFormField(
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

 Widget _buildAchievementsGrid(int completedLessons) {
  List<Map<String, String>> filteredAchievements = _achievements
      .where((achievement) {
    String title = achievement['title']!;
    // Split the title by "Completed" or "Trophy" and take the first part
    String lessonPart = title.split(' Completed').first;
    // Try parsing the lesson number
    int? lessonNumber = int.tryParse(lessonPart.split(' ').last);
    // Return true if the lesson number is not null and less than or equal to completedLessons
    return lessonNumber != null && lessonNumber <= completedLessons;
  }).toList();

  return Container(
    height: 200, // Adjust this value as needed
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredAchievements.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              filteredAchievements[index]['icon']!,
              width: 50,
              height: 50,
            ),
            SizedBox(height: 5),
            Text(
              filteredAchievements[index]['title'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildAchievementTile(Map<String, String> achievement) {
  return ListTile(
    leading: Image.asset(
      achievement['icon']!,
      height: 40,
      width: 40,
    ),
    title: Text(
      achievement['title']!,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Text(
      achievement['description']!,
      style: const TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}
  Widget _buildStars() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10), // Adjust vertical spacing here
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber), // Star icon
        const SizedBox(width: 5),
        Text(
          'Tokens: $_stars',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _buildTotalCoins() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10), // Adjust vertical spacing here
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.attach_money, color: Colors.green), // Coins icon
        const SizedBox(width: 5),
        Text(
          'Total Coins: $_totalCoins',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}


}