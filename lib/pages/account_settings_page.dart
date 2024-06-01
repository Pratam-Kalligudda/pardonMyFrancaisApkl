import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, // Remove the shadow
        centerTitle: true,
      ),
      body: _buildAccountSettingsContent(context),
    );
  }

  Widget _buildAccountSettingsContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text('Change Username'),
          subtitle: Text('Change your username'),
          leading: Icon(Icons.person),
          onTap: () {
            _showChangeUsernameDialog(context);
          },
        ),
        Divider(),
        ListTile(
          title: Text('Change Password'),
          subtitle: Text('Change your password'),
          leading: Icon(Icons.lock),
          onTap: () {
            _showChangePasswordDialog(context);
          },
        ),
        Divider(),
        ListTile(
          title: Text('Delete Account'),
          subtitle: Text('Delete your account'),
          leading: Icon(Icons.lock),
          onTap: () {
            _showDeleteAccountDialog(context);
          },
        ),
        Divider(),
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
          title: Text('Change Username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current username: current_username'),
              TextField(
                controller: newUsernameController,
                decoration: InputDecoration(
                  hintText: 'Enter new username',
                ),
                obscureText: true,
              ),
              SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement logic to update username
                String newUsername = newUsernameController.text;
                // Process the new username
                print('New Username: $newUsername');
                Navigator.pop(context);
              },
              child: Text('Save'),
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
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  hintText: 'Enter current password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 8),
              TextField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement logic to update password
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmNewPassword = confirmNewPasswordController.text;
                // Process the password change
                print('Current Password: $currentPassword');
                print('New Password: $newPassword');
                print('Confirm New Password: $confirmNewPassword');
                Navigator.pop(context);
              },
              child: Text('Save'),
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
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Implement logic to delete account
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
