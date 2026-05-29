import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Shuru mein system default mode use karega taaki phone ki setting sune
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Load theme from SharedPreferences
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // Yahan check kar rahe hain ki kya user ne pehle kabhi manually theme change ki thi?
    // Agar nahi ki (null), toh hum usko system mode par hi chhod denge.
    if (prefs.containsKey('isDarkTheme')) {
      final isDark = prefs.getBool('isDarkTheme') ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  // User jab manual button dabayega, tab yeh call hoga aur save karega
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDark);
    notifyListeners();
  }
}