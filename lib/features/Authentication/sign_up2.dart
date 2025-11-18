// This file makes up the components of the Sign Up Step 2 Screen,
// which collects additional user information such as Major, Minor, and Department. 
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';

class SignUpStep2Screen extends StatefulWidget {
  const SignUpStep2Screen({super.key});

  @override
  State<SignUpStep2Screen> createState() => _SignUpStep2ScreenState();
}

class _SignUpStep2ScreenState extends State<SignUpStep2Screen> {
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _minorController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _majorController.dispose();
    _minorController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _goBackToStep1() {
    context.go('/signup');
  }

  void _finishSignUp() {
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
                  onPressed: _goBackToStep1,
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
                            _label('Major', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _majorController,
                              hint: 'Major',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Major is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium),

                            _label('Minor', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _minorController,
                              hint: 'Minor',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Minor is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium),

                            _label('Department', labelStyle),
                            const SizedBox(height: AppSpacing.gapSmall),
                            _field(
                              controller: _departmentController,
                              hint: 'Department',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Department is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.gapMedium * 2),

                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _finishSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: AppColors.textOnPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Sign Up',
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: _inputDecoration(hint),
    );
  }
}
