import 'package:flutter/material.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart'; // Import your custom bottom navigation bar widget

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _emailController = TextEditingController(text: 'johndoe@example.com');
  final TextEditingController _bioController = TextEditingController(text: 'Software Engineer');
  final TextEditingController _locationController = TextEditingController(text: 'New York, USA');

  bool _isNameEditing = false;
  bool _isEmailEditing = false;
  bool _isBioEditing = false;
  bool _isLocationEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, // Remove the shadow
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Handle notifications button press
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              // Handle logout button press
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 70,
                    // Replace with your user's profile picture
                    backgroundImage: AssetImage('assets/icons/profile.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          // Implement photo editing functionality
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildEditableField('Name', _nameController, Icons.person_outline, () {
              setState(() {
                _isNameEditing = !_isNameEditing;
              });
              // Handle save changes for name
            }, _isNameEditing),
            const SizedBox(height: 20),
            _buildEditableField('Email', _emailController, Icons.email_outlined, () {
              setState(() {
                _isEmailEditing = !_isEmailEditing;
              });
              // Handle save changes for email
            }, _isEmailEditing),
            const SizedBox(height: 20),
            _buildEditableField('Bio', _bioController, Icons.info_outline, () {
              setState(() {
                _isBioEditing = !_isBioEditing;
              });
              // Handle save changes for bio
            }, _isBioEditing),
            const SizedBox(height: 20),
            _buildEditableField('Location', _locationController, Icons.location_on_outlined, () {
              setState(() {
                _isLocationEditing = !_isLocationEditing;
              });
              // Handle save changes for location
            }, _isLocationEditing),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Current index for the profile page
        onTap: (index) {
          // Handle navigation based on the index
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

  Widget _buildEditableField(String label, TextEditingController controller, IconData iconData, VoidCallback onPressed, bool isFieldEditing) {
    return TextFormField(
      controller: controller,
      readOnly: !isFieldEditing,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        prefixIcon: Icon(iconData, color: Theme.of(context).colorScheme.onBackground),
        suffixIcon: isFieldEditing
          ? IconButton(
              icon: const Icon(Icons.check_box), // Change to save icon when editing
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
            )
          : IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
            ),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
    );
  }
}
