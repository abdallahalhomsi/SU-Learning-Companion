import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    // After 3 seconds, go to the login route
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/login'); // same style as your CalendarScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C6AC5), // top blue
              Color(0xFF00345A), // bottom blue
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 60),
            Text(
              'SU LEARNING\nCOMPANION',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 80),
            Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                letterSpacing: 6,
                color: Color(0xFFB3F9E6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
