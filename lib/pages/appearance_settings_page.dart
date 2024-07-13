//pages/notification_settings_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppearanceSettingsPageState createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appearance',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, 
        centerTitle: true,
      ),
      body: _buildAppearanceSettingsContent(),
    );
  }

  Widget _buildAppearanceSettingsContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SwitchListTile(
          title: themeProvider.themeMode == ThemeMode.dark
           ? const Text(
                'Light Mode',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            : const Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            if (value) {
              themeProvider.setThemeMode(ThemeMode.dark);
            } else {
              themeProvider.setThemeMode(ThemeMode.light);
            }
          },
          secondary: themeProvider.themeMode == ThemeMode.dark
           ? const Icon(Icons.light_mode)
            : const Icon(Icons.dark_mode),
        ),
      const Divider(),
      ],
    );
  }
}
