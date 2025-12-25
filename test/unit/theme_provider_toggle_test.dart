import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:su_learning_companion/common/providers/theme_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ThemeProvider defaults to LIGHT for a new user and persists per-user', () async {
    final user1 = MockUser(uid: 'user1');
    final auth = MockFirebaseAuth(mockUser: user1, signedIn: true);

    final provider = ThemeProvider(auth: auth);

    await provider.loadTheme();
    expect(provider.themeMode, ThemeMode.light);

    await provider.toggleTheme();
    expect(provider.themeMode, ThemeMode.dark);

    // New instance simulating app restart for same user
    final provider2 = ThemeProvider(auth: auth);
    await provider2.loadTheme();
    expect(provider2.themeMode, ThemeMode.dark);
  });

  test('ThemeProvider forces LIGHT when not logged in', () async {
    final auth = MockFirebaseAuth(signedIn: false);

    final provider = ThemeProvider(auth: auth);

    await provider.toggleTheme(); // should not switch
    expect(provider.themeMode, ThemeMode.light);
    expect(provider.isDarkMode, isFalse);
  });
}
