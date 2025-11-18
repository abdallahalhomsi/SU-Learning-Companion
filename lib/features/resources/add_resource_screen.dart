// This file makes up the components of the Add Resources Screen,
// Which displays a form in order to add new resources to the course.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/models/resource.dart';
import '../../common/repos/resources_repo.dart';
import '../../data/fakes/fake_resources_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class AddResourceScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const AddResourceScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  final ResourcesRepo _resourcesRepo = FakeResourcesRepo();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _link = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _link.dispose();
    super.dispose();
  }

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

    setState(() => _isSubmitting = true);

    final resource = Resource(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: widget.courseId,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      link: _link.text.trim(),
      createdAt: DateTime.now(),
    );

    await _resourcesRepo.addResource(resource);

    if (!mounted) return;
    context.pop<bool>(true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textOnPrimary, size: 20),
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
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter title' : null,
                decoration: _fieldDecoration('Title'),
              ),
              const SizedBox(height: AppSpacing.gapMedium),
              TextFormField(
                controller: _desc,
                maxLines: 4,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter description' : null,
                decoration: _fieldDecoration('Description'),
              ),
              const SizedBox(height: AppSpacing.gapMedium),
              TextFormField(
                controller: _link,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter link' : null,
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
                  child: Text(
                    'Submit',
                    style: AppTextStyles.primaryButton,
                  ),
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
