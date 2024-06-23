// models/user.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Represents a user with their basic information.
class User with ChangeNotifier {
  final String username;
  final String email;
  final String registrationDate;

  User({
    required this.username,
    required this.email,
    required this.registrationDate,
  });

  /// Converts a JSON map into a User object.
  factory User.fromJson(Map<String, dynamic> json) {
    if (json['username'] == null || json['email'] == null || json['registration_date'] == null) {
      throw const FormatException("Invalid JSON format for User");
    }

    final DateTime date = DateTime.parse(json['registration_date']);
    final String formattedDate = DateFormat.yMMMMd().format(date);
    
    return User(
      username: json['username'],
      email: json['email'],
      registrationDate: formattedDate,
    );
  }
}
