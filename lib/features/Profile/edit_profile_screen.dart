// lib/features/Profile/edit_profile_screen.dart


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> currentData;

  const EditProfileScreen({
    super.key,
    required this.currentData,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _studentIdCtrl;
  late TextEditingController _majorCtrl;
  late TextEditingController _minorCtrl;
  late TextEditingController _deptCtrl;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _text => Theme.of(context).colorScheme.onSurface;
  Color get _idleLine => _isDark ? const Color(0xFF334155) : const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    final d = widget.currentData;
    _nameCtrl = TextEditingController(text: d['name'] ?? d['fullName'] ?? '');
    _studentIdCtrl = TextEditingController(text: d['studentId'] ?? d['id'] ?? '');
    _majorCtrl = TextEditingController(text: d['major'] ?? '');
    _minorCtrl = TextEditingController(text: d['minor'] ?? '');
    _deptCtrl = TextEditingController(text: d['department'] ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _studentIdCtrl.dispose();
    _majorCtrl.dispose();
    _minorCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': _nameCtrl.text.trim(),
        'studentId': _studentIdCtrl.text.trim(),
        'major': _majorCtrl.text.trim(),
        'minor': _minorCtrl.text.trim(),
        'department': _deptCtrl.text.trim(),
      });

      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text('Edit Profile', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Icon(Icons.check, color: Colors.white),
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: AppSpacing.screen,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Edit Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildInlineField(context, 'Name', _nameCtrl),
                _buildInlineField(context, 'Student ID', _studentIdCtrl),
                _buildInlineField(context, 'Major', _majorCtrl),
                _buildInlineField(context, 'Minor', _minorCtrl),
                _buildInlineField(context, 'Department', _deptCtrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineField(BuildContext context, String label, TextEditingController controller) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      height: 1.4,
      color: _text,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Text(
              '$label: ',
              style: baseStyle?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: baseStyle,
              cursorColor: _text,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _idleLine),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryBlue),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: _idleLine),
                ),
              ),
              validator: (v) => v != null && v.trim().isEmpty ? 'Required' : null,
            ),
          ),
        ],
      ),
    );
  }
}
