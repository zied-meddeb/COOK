import 'package:flutter/material.dart';
import 'app_colors.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  
  AppThemeMode get themeMode => _themeMode;
  
  bool isDarkMode(BuildContext context) {
    if (_themeMode == AppThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == AppThemeMode.dark;
  }
  
  AppThemeColors colors(BuildContext context) {
    return isDarkMode(context) ? AppThemeColors.dark : AppThemeColors.light;
  }
  
  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
