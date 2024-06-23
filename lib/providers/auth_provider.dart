// providers/auth_provider.dart

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // State variable to indicate loading status
  late bool _isLoading = false;

  // Getter for loading status
  bool get isLoading => _isLoading;

  // Method to update loading status and notify listeners
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
