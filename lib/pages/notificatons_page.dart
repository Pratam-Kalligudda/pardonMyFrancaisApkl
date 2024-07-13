//pages/notifications_page.dart

import 'package:flutter/material.dart';
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
          fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildNotificationsContent(context),
    );
  }

  Widget _buildNotificationsContent(BuildContext context) {
    List<String> notifications = [];

    if (notifications.isEmpty) {
      return Center(
        child: Text('No new notifications',
        style: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
          );
        },
      );
    }
  }
}
