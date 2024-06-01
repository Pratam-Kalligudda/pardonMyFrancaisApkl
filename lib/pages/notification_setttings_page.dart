import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationsSettingsPageState createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0, // Remove the shadow
        centerTitle: true,
      ),
      body: _buildNotificationsSettingsContent(),
    );
  }

  Widget _buildNotificationsSettingsContent() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        SwitchListTile(
          title: Text('Receive Notifications'),
          value: _receiveNotifications,
          onChanged: (bool value) {
            setState(() {
              _receiveNotifications = value;
            });
          },
          secondary: Icon(Icons.notifications_active),
        ),
        Divider(),
        // Add more notifications settings options as needed
      ],
    );
  }
}
