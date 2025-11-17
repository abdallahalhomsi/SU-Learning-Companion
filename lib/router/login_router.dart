import 'package:flutter/material.dart';
import '../features/Authentication/sign_in.dart';

class LoginRouter {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const SignInScreen(),
  };
}
