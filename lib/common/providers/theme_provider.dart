import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// providers for managing app theme (light/dark mode)
/// Saves user's theme preference using SharedPreferences
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Load saved theme preference on app start
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      notifyListeners();
      debugPrint('✅ Theme loaded: ${_isDarkMode ? "Dark" : "Light"}');
    } catch (e) {
      debugPrint('❌ Failed to load theme: $e');
      _isDarkMode = false;
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      debugPrint('✅ Theme saved: ${_isDarkMode ? "Dark" : "Light"}');
    } catch (e) {
      debugPrint('❌ Failed to save theme: $e');
    }
  }

  /// Set specific theme
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) return;

    _isDarkMode = isDark;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      debugPrint('✅ Theme set to: ${_isDarkMode ? "Dark" : "Light"}');
    } catch (e) {
      debugPrint('❌ Failed to save theme: $e');
    }
  }
}