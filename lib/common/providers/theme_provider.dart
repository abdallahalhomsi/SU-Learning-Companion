import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Manages app theme (light/dark) and persists it using SharedPreferences.
///
/// FIX:
/// - Theme is stored PER-USER (key includes uid)
/// - On auth changes (login/logout/register), we reset to LIGHT immediately,
///   then load the saved preference for that user.
/// - Logged-out users ALWAYS see LIGHT.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKeyPrefix = 'isDarkMode_';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  StreamSubscription<User?>? _authSub;
  String? _activeUid;

  ThemeProvider() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  String _keyFor(String uid) => '$_themeKeyPrefix$uid';

  void _onAuthChanged(User? user) {
    final uid = user?.uid;

    // If user changed (including logout), reset to LIGHT immediately.
    if (_activeUid != uid) {
      _activeUid = uid;
      _isDarkMode = false;
      notifyListeners();
    }

    // Then load that user's saved theme (if any).
    loadTheme();
  }

  /// Load saved theme preference on app start / auth change
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;

      // Logged out => always light
      if (user == null) {
        _isDarkMode = false;
        notifyListeners();
        return;
      }

      final key = _keyFor(user.uid);

      // New user => default to light and persist
      if (!prefs.containsKey(key)) {
        _isDarkMode = false;
        await prefs.setBool(key, false);
        notifyListeners();
        return;
      }

      _isDarkMode = prefs.getBool(key) ?? false;
      notifyListeners();
    } catch (_) {
      _isDarkMode = false;
      notifyListeners();
    }
  }

  /// Toggle between light and dark theme (per-user)
  Future<void> toggleTheme() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isDarkMode = false;
      notifyListeners();
      return;
    }

    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFor(user.uid), _isDarkMode);
    } catch (_) {}
  }

  /// Set specific theme (per-user)
  Future<void> setTheme(bool isDark) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (_isDarkMode != false) {
        _isDarkMode = false;
        notifyListeners();
      }
      return;
    }

    if (_isDarkMode == isDark) return;

    _isDarkMode = isDark;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFor(user.uid), _isDarkMode);
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
