import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';

import 'package:su_learning_companion/common/providers/theme_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ThemeProvider default is light', () async {
    final auth = MockFirebaseAuth(signedIn: false);

    final provider = ThemeProvider(auth: auth);
    expect(provider.themeMode, equals(ThemeMode.light));
    expect(provider.isDarkMode, isFalse);
  });
}
