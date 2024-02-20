import 'package:flutter/material.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int _currentIndex = 0;
  List<String> _navigationStack = ['WelcomePage'];

  int get currentIndex => _currentIndex;
  List<String> get navigationStack => _navigationStack;

  void updateIndex(int newIndex, String pageName) {
    _currentIndex = newIndex;
    _navigationStack.add(pageName);
    notifyListeners();
  }

  void popNavigationStack() {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
      notifyListeners();
    }
  }
}
