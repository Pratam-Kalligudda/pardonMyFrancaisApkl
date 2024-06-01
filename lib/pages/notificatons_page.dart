//pages/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/bottom_navigation_bar.dart'; // Import your custom bottom navigation bar widget

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
      body: _buildNotificationsContent(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Current index for the profile page
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // Do nothing as it's the current page
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildNotificationsContent() {
    // Your logic to fetch notifications can go here
    List<String> notifications = [];

    if (notifications.isEmpty) {
      return const Center(
        child: Text('No new notifications'),
      );
    } else {
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
            // Customize notification tile as needed
          );
        },
      );
    }
  }
}
