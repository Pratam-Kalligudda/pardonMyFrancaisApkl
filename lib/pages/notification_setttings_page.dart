//pages/notification_settings_page.dart

import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications Settings',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, 
        centerTitle: true,
      ),
      body: _buildNotificationsSettingsContent(),
    );
  }

  Widget _buildNotificationsSettingsContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SwitchListTile(
          title: const Text(
            'Receive Notifications',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          value: _receiveNotifications,
          onChanged: (bool value) {
            setState(() {
              _receiveNotifications = value;
            });
          },
          secondary: _receiveNotifications
             ? const Icon(Icons.notifications_active)
              : const Icon(Icons.notifications_off),
        ),
        const Divider(),
      ],
    );
  }
}
