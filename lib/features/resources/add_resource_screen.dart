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

/// A form screen that allows users to contribute new learning resources to a specific course.
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
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _link = TextEditingController();

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

  /// Validates the form input and persists the new resource to Firestore via the repository.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showValidationDialog();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // We pass an empty ID and empty createdBy; the repository layer is responsible
      // for generating the unique ID and assigning the current user's UID securely.
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
      context.pop<bool>(true); // Return true to indicate successful addition
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
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Resource - ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.screen,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter title' : null,
                decoration: _fieldDecoration('Title'),
              ),
              const SizedBox(height: AppSpacing.gapMedium),
              TextFormField(
                controller: _desc,
                maxLines: 4,
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter description' : null,
                decoration: _fieldDecoration('Description'),
              ),
              const SizedBox(height: AppSpacing.gapMedium),
              TextFormField(
                controller: _link,
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter link' : null,
                decoration: _fieldDecoration('Link'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Submit', style: AppTextStyles.primaryButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.black54),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}