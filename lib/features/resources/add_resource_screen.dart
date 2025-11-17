
import 'package:flutter/material.dart';
import '../models/resource.dart';
import '../repositories/resources_repo.dart';

class AddResourceScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const AddResourceScreen({
    Key? key,
    required this.courseId,
    this.courseName = 'Course Name',
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

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

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Resource"),
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                validator: (v) =>
                    v!.trim().isEmpty ? "Enter title" : null,
                decoration: _field(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                maxLines: 4,
                validator: (v) =>
                    v!.trim().isEmpty ? "Enter description" : null,
                decoration: _field(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _link,
                validator: (v) =>
                    v!.trim().isEmpty ? "Enter link" : null,
                decoration: _field(),
              ),
              const Spacer(),
              ElevatedButton(
                style: _btn(),
                onPressed: _isSubmitting ? null : _submit,
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _field() => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  ButtonStyle _btn() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      );
}
