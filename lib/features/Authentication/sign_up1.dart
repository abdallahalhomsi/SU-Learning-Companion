// This file makes up the components of the Sign Up Step 1 Screen,
// which collects user information such as Full Name, Student ID, Email, and Password.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';

class SignUpStep1Screen extends StatefulWidget {
  const SignUpStep1Screen({super.key});

  @override
  State<SignUpStep1Screen> createState() => _SignUpStep1ScreenState();
}

class _SignUpStep1ScreenState extends State<SignUpStep1Screen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
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

    context.go('/signup_2');
  }

  void _goBackToLogin() {
    context.go('/login');
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: AppColors.inputGrey),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: AppColors.inputGrey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
      ),
      errorStyle: AppTextStyles.errorText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        );

    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: _goBackToLogin,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),

              const SizedBox(height: 40),

              Image.asset(
                'lib/common/assets/sabanci_logo.jpeg',
                height: 80,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 35),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: AppSpacing.card,
                      constraints: const BoxConstraints(maxWidth: 380),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Full Name', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _fullNameController,
                              hint: 'Full Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium),

                            _label('Student ID', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _studentIdController,
                              hint: 'Student ID',
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Student ID is required';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
                                  return 'Invalid student ID';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium),

                            _label('Email', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _emailController,
                              hint: 'email@sabanciuniv.edu',
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!email.endsWith('@sabanciuniv.edu')) {
                                  return 'Invalid email, must end with @sabanciuniv.edu';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium),

                            _label('Password', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _passwordController,
                              hint: 'Password',
                              obscure: true,
                              validator: (value) {
                                final password = value?.trim() ?? '';
                                if (password.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium),

                            _label('Confirm Password', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _confirmPasswordController,
                              hint: 'Confirm Password',
                              obscure: true,
                              validator: (value) {
                                final confirm = value?.trim() ?? '';
                                if (confirm.isEmpty) {
                                  return 'Confirm password is required';
                                }
                                if (confirm !=
                                    _passwordController.text.trim()) {
                                  return 'Incorrect password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium * 2),

                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _goToNextStep,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: AppColors.textOnPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Next',
                                  style: AppTextStyles.primaryButton,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.gapMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, TextStyle? style) {
    return Text(text, style: style);
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: _inputDecoration(hint),
    );
  }
}
