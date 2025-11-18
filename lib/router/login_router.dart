// This file makes up the components of the Login Router,
// which defines the navigation for the Login feature of the app.
// It includes the main route for the SignIn Screen.S

import 'package:flutter/material.dart';
import '../features/Authentication/sign_in.dart';

class LoginRouter {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const SignInScreen(),
  };
}
