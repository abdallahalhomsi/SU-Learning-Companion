// This file makes up the components of the Welcome Screen(splash screen),
// which displays the app name and a welcome message with a light bulb icon.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/utils/app_spacing.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  Future<void> _startUp() async {
    await FirebaseAuth.instance.authStateChanges().first;
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _opacity = 0.0;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        opacity: _opacity,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0C6AC5),
                Color(0xFF00345A),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              const Text(
                'SU LEARNING\nCOMPANION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SplashFont',
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.5,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 80),

              const Text(
                'WELCOME',
                style: TextStyle(
                  fontFamily: 'SplashFont',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 8,
                  color: Color(0xFFB3F9E6),
                ),
              ),

              const SizedBox(height: 20),

              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/d/dd/Simple_light_bulb_graphic_white.png',
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSpacing.gapMedium),
            ],
          ),
        ),
      ),
    );
  }
}
