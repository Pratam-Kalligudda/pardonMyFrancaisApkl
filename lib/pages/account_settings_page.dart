//pages/account_settings_page.dart

import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

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

  void _showChangeUsernameDialog(BuildContext context) {
    TextEditingController newUsernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Current username: current_username'),
              TextField(
                controller: newUsernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter new username',
                ),
                obscureText: true,
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
              onPressed: () {
                // Implement logic to update username
                String newUsername = newUsernameController.text;
                print('New Username: $newUsername');
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
              onPressed: () {
                // Implement logic to update password
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmNewPassword = confirmNewPasswordController.text;
                print('Current Password: $currentPassword');
                print('New Password: $newPassword');
                print('Confirm New Password: $confirmNewPassword');
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
                // Implement logic to delete account
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
