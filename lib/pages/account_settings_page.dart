//pages/account_settings_page.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:french_app/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String apiUrl = dotenv.env['MY_API_URL']!;

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
        Uri.parse('$apiUrl/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        return userData['username'];
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
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
          title: Text(
            'Change Username',
            style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            ),
          ),
          leading: const Icon(Icons.person),
          onTap: () {
            _showChangeUsernameDialog(context);
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            'Change Password',
            style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            ),
          ),
          leading: const Icon(Icons.lock),
          onTap: () {
            _showChangePasswordDialog(context);
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
            'Delete Account',
            style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            ),
          ),
          leading: const Icon(Icons.delete),
          onTap: () {
            _showDeleteAccountDialog(context);
          },
        ),
        const Divider(),
      ],
    );
  }

  void _showChangeUsernameDialog(BuildContext context) async {
    TextEditingController newUsernameController = TextEditingController();
    String? currentUsername = await _fetchCurrentUsername();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change your username',
            style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Current username: $currentUsername',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
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
        Uri.parse('$apiUrl/updateProfile'),
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
        showStyledSnackBar(context, 'Username updated successfully');
      } else {
        showStyledSnackBar(context, 'Failed to update username. Status code: ${response.statusCode}');
      }
    } catch (error) {
      showStyledSnackBar(context, 'Error updating username: $error');
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
          title: Text(
            'Change your password',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter current password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                controller: newPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
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
                if (newPassword.isNotEmpty && newPassword == confirmNewPassword) {
                  await _updatePassword(currentPassword, newPassword, context);
                } else {
                  showStyledSnackBar(context, 'New passwords do not match');
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

  Future<void> _updatePassword(String oldPassword, String newPassword, BuildContext context) async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('$apiUrl/updateProfile'),
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
        showStyledSnackBar(context, 'Password updated successfully. Please login again.');
        await Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
      } else if (response.statusCode == 401) {
        showStyledSnackBar(context, 'Unauthorized request. Please log in again.');
      } else {
        showStyledSnackBar(context, 'Failed to update password. Status code: ${response.statusCode}');
      }
    } catch (error) {
      showStyledSnackBar(context, 'Error updating password: $error');
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
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

  void _deleteUser(BuildContext context) async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.delete(
        Uri.parse('$apiUrl/deleteUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        showStyledSnackBar(context, 'Account deleted successfully.');
        await Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        showStyledSnackBar(context, 'Failed to delete account. Status code: ${response.statusCode}');
      }
    } catch (error) {
      showStyledSnackBar(context, 'Error deleting account: $error');
    }
  }
}
