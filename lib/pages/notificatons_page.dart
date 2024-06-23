//pages/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart';
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildNotificationsContent(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/profile');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildNotificationsContent(BuildContext context) {
    List<String> notifications = [];

    if (notifications.isEmpty) {
      return Center(
        child: Text('No new notifications',
        style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface),
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
