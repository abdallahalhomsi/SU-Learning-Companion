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

  /// 🔗 URL validation
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

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppColors.errorRed,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppColors.errorRed,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter title' : null,
                    ),


                    const SizedBox(height: AppSpacing.gapMedium),

                    TextFormField(
                      controller: _desc,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter description' : null,
                    ),

                    const SizedBox(height: AppSpacing.gapMedium),

                    TextFormField(
                      controller: _link,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Link',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter link';
                        }
                        if (!_isValidUrl(v)) {
                          return 'Enter a valid link (https://...)';
                        }
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
