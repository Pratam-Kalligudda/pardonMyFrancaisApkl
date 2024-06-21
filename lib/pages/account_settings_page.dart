//pages/account_settings_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _fetchCurrentUsername() async {
  try {
    final jwtToken = await _getJwtToken();
    if (jwtToken == null) {
      throw Exception('JWT token not found');
    }

    final response = await http.get(
      Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return userData['username'];
    } else {
      print('Failed to fetch current username. Status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error fetching current username: $error');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildAccountSettingsContent(context),
    );
  }

  Widget _buildAccountSettingsContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: const Text('Change Username'),
          subtitle: const Text('Change your username'),
          leading: const Icon(Icons.person),
          onTap: () {
            _showChangeUsernameDialog(context);
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Change Password'),
          subtitle: const Text('Change your password'),
          leading: const Icon(Icons.lock),
          onTap: () {
            _showChangePasswordDialog(context);
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Delete Account'),
          subtitle: const Text('Delete your account'),
          leading: const Icon(Icons.lock),
          onTap: () {
            _showDeleteAccountDialog(context);
          },
        ),
        const Divider(),
        // Add more settings options as needed
      ],
    );
  }

  void _deleteUser(BuildContext context) async {
  try {
    final jwtToken = await _getJwtToken();
    if (jwtToken == null) {
      throw Exception('JWT token not found');
    }

    final response = await http.delete(
      Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/deleteUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      // Remove tokens from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      // Account deleted successfully
      // Navigate back to welcome page or any other appropriate action
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacementNamed(context, '/'); // Navigate to welcome page
    } else {
      print('Failed to delete account. Status code: ${response.statusCode}');
      // Optionally, show an error message to the user
    }
  } catch (error) {
    print('Error deleting account: $error');
    // Handle network errors or other exceptions
  }
}

void _showSignInSnackbar(BuildContext context, String message) {
    showStyledSnackBar(context, message);
  }

void _showChangeUsernameDialog(BuildContext context) async {
  TextEditingController newUsernameController = TextEditingController();
  String? currentUsername = await _fetchCurrentUsername();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Change Username'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current username: $currentUsername'),
            TextField(
              controller: newUsernameController,
              decoration: const InputDecoration(
                hintText: 'Enter new username',
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String newUsername = newUsernameController.text;
              if (newUsername.isNotEmpty) {
                await _updateUsername(newUsername, context);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

Future<void> _updateUsername(String newUsername, BuildContext context) async {
  try {
    final jwtToken = await _getJwtToken();
    if (jwtToken == null) {
      throw Exception('JWT token not found');
    }

    final response = await http.post(
      Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/updateProfile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, dynamic>{
        'updates': [
          {'field': 'username', 'value': newUsername},
        ],
      }),
    );

    if (response.statusCode == 200) {
    // Clear any authentication tokens or data here if needed
    print('Username updated successfully');
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');
    
    // // Navigate to the sign-in page
    // Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
    } else {
      print('Failed to update username. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update username. Status code: ${response.statusCode}'),
        ),
      );
      // Optionally, show an error message to the user
    }
  } catch (error) {
    print('Error updating username: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating username: $error'),
      ),
    );
    // Handle network errors or other exceptions
  }
}

  Future<void> _updatePassword(String oldPassword, String newPassword, BuildContext context) async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/updateProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(<String, dynamic>{
          'updates': [
            {'field': 'password', 'value': newPassword, 'old_value': oldPassword},
          ],
        }),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        print('Password updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/signIn', (route) => false);
      } else if (response.statusCode == 401) {
        print('Failed to update password. Unauthorized (401).');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized request. Please log in again.'),
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate to sign-in page to re-authenticate
        // Navigator.of(context).pushNamedAndRemoveUntil('/signIn', (route) => false);
      } else {
        print('Failed to update password. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update password. Status code: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error updating password: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating password: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter current password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmNewPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Confirm new password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmNewPassword = confirmNewPasswordController.text;
                print('Current Password: $currentPassword');
                print('New Password: $newPassword');
                print('Confirm New Password: $confirmNewPassword');
                if (newPassword.isNotEmpty && newPassword == confirmNewPassword) {
                  await _updatePassword(currentPassword, newPassword, context);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _deleteUser(context);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
}
