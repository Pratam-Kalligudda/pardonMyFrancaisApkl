// models/user.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User with ChangeNotifier {
  final String username;
  final String email;
  final String registrationDate;

  User({
    required this.username,
    required this.email,
    required this.registrationDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final DateTime date = DateTime.parse(json['registration_date']);
    final String formattedDate = DateFormat.yMMMMd().format(date);
    return User(
      username: json['username'],
      email: json['email'],
      registrationDate: formattedDate,
    );
  }
}
