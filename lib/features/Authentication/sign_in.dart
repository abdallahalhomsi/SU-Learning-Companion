// This file makes up the components of the Sign In Screen,
// which allows users to input their email and password to sign in.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:su_learning_companion/common/providers/auth_provider.dart';
import '../../common/widgets/loading_spinner.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ UPDATED submit method (uses AuthProvider)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Please fix the form'),
          content: const Text(
            'Some fields are missing or invalid.\n'
            'Fields with red text need your attention.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();

    final success = await auth.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sign in failed'),
          content: Text(auth.error ?? 'Sign in failed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.inputGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.inputGrey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.isLoading;

    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue,
              Color(0xFF001F4F),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screen,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/common/assets/sabanci_logo.jpeg',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: AppSpacing.gapMedium * 2),
                Container(
                  width: double.infinity,
                  padding: AppSpacing.card,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Email', style: labelStyle),
                        const SizedBox(height: AppSpacing.gapSmall),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration('Email'),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) return 'Email is required';
                            if (!email.endsWith('@sabanciuniv.edu')) {
                              return 'Invalid email, must end with @sabanciuniv.edu';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.gapMedium),
                        Text('Password', style: labelStyle),
                        const SizedBox(height: AppSpacing.gapSmall),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: _fieldDecoration('Password'),
                          validator: (value) {
                            final password = value?.trim() ?? '';
                            if (password.isEmpty) return 'Password is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.gapMedium * 2),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: AppColors.textOnPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: isLoading ? null : _submit,
                            child: isLoading
                                ? const LoadingSpinner()
                                : const Text(
                                    'Sign In',
                                    style: AppTextStyles.primaryButton,
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.gapMedium),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => context.go('/signup'),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
