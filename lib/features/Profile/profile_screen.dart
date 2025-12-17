// lib/features/Profile/profile_screen.dart
//
// Profile Screen (Firebase):
// - Shows CURRENT logged-in user's info from Firestore: users/{uid}
// - Falls back to FirebaseAuth displayName/email when Firestore fields are missing
// - Log out = FirebaseAuth.signOut() then go to /login

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// REQUIRED for context.watch / context.read
import 'package:provider/provider.dart';
import '../../common/providers/theme_provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _str(dynamic v, {String fallback = '-'}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  Future<Map<String, dynamic>?> _loadUserDoc(String uid) async {
    final snap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snap.data();
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Not logged in
    if (user == null) {
      return AppScaffold(
        currentIndex: 2,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text('PROFILE', style: AppTextStyles.appBarTitle),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text('Go to login', style: AppTextStyles.primaryButton),
          ),
        ),
      );
    }

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
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _loadUserDoc(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data ?? {};

            // Adjust these keys to match what you saved during sign-up.
            // Common patterns:
            // - name / fullName
            // - studentId / id
            // - major / minor / department
            final name = _str(
              data['name'] ?? data['fullName'],
              fallback: _str(user.displayName, fallback: ''),
            );
            final studentId = _str(data['studentId'] ?? data['id']);
            final email = _str(data['email'], fallback: _str(user.email));
            final major = _str(data['major']);
            final minor = _str(data['minor']);
            final department = _str(data['department']);

            return Column(
              children: [
                // ✅ Theme toggle is now part of the widget tree
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Switch between light and dark theme'),
                  value: context.watch<ThemeProvider>().isDarkMode,
                  onChanged: (value) {
                    // keep your provider behavior; just ensure it is in the tree
                    context.read<ThemeProvider>().toggleTheme();
                  },
                  secondary: Icon(
                    context.watch<ThemeProvider>().isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          _InfoLine(label: 'Name', value: name.isEmpty ? '-' : name),
                          _InfoLine(label: 'Student ID', value: studentId),
                          _InfoLine(label: 'Email', value: email),
                          _InfoLine(label: 'Major', value: major),
                          _InfoLine(label: 'Minor', value: minor),
                          _InfoLine(label: 'Department', value: department),

                          const SizedBox(height: 32),

                          Center(
                            child: SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Log Out'),
                                      content: const Text('Are you sure you want to log out?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await _logout(context);
                                          },
                                          child: const Text('Log Out'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.errorRed,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text('Log out', style: AppTextStyles.primaryButton),
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
            );
          },
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
            TextSpan(text: value.isEmpty ? '-' : value),
          ],
        ),
      ),
    );
  }
}
