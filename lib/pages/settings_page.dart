//pages/setting_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/pages/account_settings_page.dart';
import 'package:french_app/pages/appearance_settings_page.dart';
import 'package:french_app/pages/notification_setttings_page.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildSettingsContent(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.popAndPushNamed(context, '/home');
              break;
            case 1:
              Navigator.popAndPushNamed(context, '/profile');
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
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final packageInfo = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Notifications Settings',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              leading: const Icon(Icons.notifications),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsSettingsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              leading: const Icon(Icons.palette),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppearanceSettingsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'App Version',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                'Version ${packageInfo.version}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              leading: const Icon(Icons.info),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}