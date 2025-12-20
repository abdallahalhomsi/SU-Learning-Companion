import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


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

    if (_activeUid != uid) {
      _activeUid = uid;
      _isDarkMode = false;
      notifyListeners();
    }

    loadTheme();
  }


  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _isDarkMode = false;
        notifyListeners();
        return;
      }

      final key = _keyFor(user.uid);

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
