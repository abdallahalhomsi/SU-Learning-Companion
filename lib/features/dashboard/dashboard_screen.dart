// This file makes up the components of the Dashboard Screen,
// Which includes a bottom navigation bar to switch between different tabs.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int idx = 0;

  final pages = const [
    HomeTab(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: const Text(
          'SU Learning Companion',
          style: AppTextStyles.appBarTitle,
        ),
      ),

      body: pages[idx],

      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        backgroundColor: AppColors.cardBackground,
        indicatorColor: AppColors.primaryBlue.withOpacity(0.08),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (states) {
            final base = Theme.of(context).textTheme.bodySmall;
            final isSelected = states.contains(WidgetState.selected);
            return base?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.primaryBlue
                  : Colors.grey[700],
            );
          },
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.style),
            label: 'Flashcards',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screen,
      child: Center(
        child: Text(
          'Today overview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
        ),
      ),
    );
  }
}
