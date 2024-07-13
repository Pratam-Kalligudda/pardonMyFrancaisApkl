// providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.light;
  bool _initialized = false;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider(BuildContext context) {
    initializeTheme(context);
    WidgetsBinding.instance.addObserver(this);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void initializeTheme(BuildContext context) {
    if (_initialized) return;
    var brightness = MediaQuery.of(context).platformBrightness;
    _themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    _initialized = true;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = SchedulerBinding.instance.window.platformBrightness;
    setThemeMode(brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
