// This file makes up the components of the SignUp Router,
// which defines the navigation for the SignUp feature of the app.
// It includes routes for the two steps of the SignUp process.

import 'package:flutter/material.dart';
import '../features/Authentication/sign_up1.dart';
import '../features/Authentication/sign_up2.dart';

class SignUpRouter {
  static Map<String, WidgetBuilder> routes = {
    '/signup': (context) => const SignUpStep1Screen(),
    '/signup_2': (context) => const SignUpStep2Screen(),
  };
}