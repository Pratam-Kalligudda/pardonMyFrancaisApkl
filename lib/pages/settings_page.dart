//pages/setting_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/pages/account_settings_page.dart';
import 'package:french_app/pages/notification_setttings_page.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
import 'package:french_app/providers/theme_provider.dart'; // Import your ThemeProvider
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final packageInfo = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text('Account Settings'),
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
              title: const Text('Notifications Settings'),
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
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.dark_mode),
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  if (value) {
                    themeProvider.setThemeMode(ThemeMode.dark);
                  } else {
                    themeProvider.setThemeMode(ThemeMode.light);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('App Version'),
              subtitle: Text('Version ${packageInfo.version}'),
              leading: const Icon(Icons.info),
            ),
          ],
        );
      },
    );
  }
}