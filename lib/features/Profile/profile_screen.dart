// This file makes up the components of the Profile Screen,
// Which displays the information the user registered with and can log out.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const String studentName = 'John Doe';
    const String studentId = '11111';
    const String email = 'johndoe@sabanciuniv.edu';
    const String major = 'Computer Science';
    const String minor = 'Business Analytics';
    const String department = 'FENS';

    return AppScaffold(
      currentIndex: 2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'PROFILE',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: AppSpacing.screen,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Student Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _InfoLine(
                        label: 'Name',
                        value: studentName,
                      ),
                      const _InfoLine(
                        label: 'Student ID',
                        value: studentId,
                      ),
                      const _InfoLine(
                        label: 'Email',
                        value: email,
                      ),
                      const _InfoLine(
                        label: 'Major',
                        value: major,
                      ),
                      const _InfoLine(
                        label: 'Minor',
                        value: minor,
                      ),
                      const _InfoLine(
                        label: 'Department',
                        value: department,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Log Out'),
                                    content: const Text(
                                      'Are you sure you want to log out?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          context.go('/login');
                                        },
                                        child: const Text('Log Out'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.errorRed,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Log out',
                              style: AppTextStyles.primaryButton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gapSmall),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.4,
      color: AppColors.textPrimary,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
