// providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:french_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
