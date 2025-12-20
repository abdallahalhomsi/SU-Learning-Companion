// lib/features/resources/add_resource_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/models/resource.dart';
import '../../common/repos/resources_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class AddResourceScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const AddResourceScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  late final ResourcesRepo _resourcesRepo;

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _link = TextEditingController();

  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resourcesRepo = context.read<ResourcesRepo>();
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _link.dispose();
    super.dispose();
  }

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showValidationDialog();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final resource = Resource(
        id: '',
        courseId: widget.courseId,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        link: _link.text.trim(),
        createdBy: '',
        createdAt: DateTime.now(),
      );

      await _resourcesRepo.addResource(resource);

      if (!mounted) return;
      context.pop<bool>(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding resource: $e')),
      );
    }
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Please fix the form'),
        content: const Text(
          'Some fields are missing or invalid.\n'
              'Fields with red text need your attention.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(BuildContext context, String label, {String? hint}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,


      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),


      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : Colors.grey,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 2,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.errorRed),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.errorRed, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Resource - ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppSpacing.screen,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _title,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: _decoration(context, 'Title'),
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter title' : null,
                    ),
                    const SizedBox(height: AppSpacing.gapMedium),
                    TextFormField(
                      controller: _desc,
                      maxLines: 4,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: _decoration(context, 'Description'),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Enter description'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.gapMedium),
                    TextFormField(
                      controller: _link,
                      keyboardType: TextInputType.url,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: _decoration(context, 'Link', hint: 'https://...'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter link';
                        if (!_isValidUrl(v)) return 'Enter a valid link (https://...)';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Add Resource',
                  style: AppTextStyles.primaryButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
