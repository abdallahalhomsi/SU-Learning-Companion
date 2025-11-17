import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      
      setState(() {
        _opacity = 0.0;
      });

      
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            children: const [
              SizedBox(height: 60),

              Text(
                'SU LEARNING\nCOMPANION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.5,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 80),

              Text(
                'WELCOME',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: Color(0xFFB3F9E6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
