import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///Reusable scaffold widget with bottom navigation bar (home, calendar, profile)
class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFF003366),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          //Don't navigate if already on the selected screen
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}