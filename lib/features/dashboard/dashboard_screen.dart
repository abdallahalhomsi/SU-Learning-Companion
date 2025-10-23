import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int idx = 0;
  final pages = const [HomeTab(), Placeholder(), Placeholder(), Placeholder(), Placeholder()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SU Learning Companion')),
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.style), label: 'Flashcards'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Today overview'));
}

/// Dashboard screen.
/// - Hosts bottom navigation and "Home" summary.
/// Frontend owns layout.
/// Future: show next tasks, quick timer, and shortcuts.