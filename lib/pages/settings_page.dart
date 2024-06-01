import 'package:flutter/material.dart';
import 'package:french_app/pages/account_settings_page.dart';
import 'package:french_app/pages/notification_setttings_page.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, // Remove the shadow
        centerTitle: true,
      ),
      body: _buildSettingsContent(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Current index for the settings page
        onTap: (index) {
          // Handle navigation based on the index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/notifications');
              break;
            case 2:
              // Do nothing as it's the current page
              break;
          }
        },
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text('Account Settings'),
          leading: Icon(Icons.account_circle),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountSettingsPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          title: Text('Notifications Settings'),
          leading: Icon(Icons.notifications),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsSettingsPage()),
            );
          },
        ),
        Divider(),
        // Add more settings options as needed
      ],
    );
  }
}
