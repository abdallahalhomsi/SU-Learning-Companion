// lib/features/resources/resource_details_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/models/resource.dart';
import '../../common/repos/resources_repo.dart';
import '../../data/fakes/fake_resources_repo.dart';

class ResourceDetailsScreen extends StatefulWidget {
  final Resource resource;
  final String courseId;
  final String courseName;

  const ResourceDetailsScreen({
    Key? key,
    required this.resource,
    required this.courseId,
    this.courseName = 'Course Name',
  }) : super(key: key);

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  final ResourcesRepo _repo = FakeResourcesRepo();

  bool _editing = false;
  bool _loading = false;

  late TextEditingController _title;
  late TextEditingController _desc;
  late TextEditingController _link;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.resource.title);
    _desc = TextEditingController(text: widget.resource.description);
    _link = TextEditingController(text: widget.resource.link);
  }

  Future<void> _saveEdit() async {
    setState(() => _loading = true);

    final updated = Resource(
      id: widget.resource.id,
      courseId: widget.resource.courseId,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      link: _link.text.trim(),
      createdAt: widget.resource.createdAt,
    );

    await _repo.updateResource(updated);

    if (!mounted) return;
    setState(() => _loading = false);

    // back to list, signal "changed"
    context.pop<bool>(true);
  }

  Future<void> _delete() async {
    await _repo.deleteResource(widget.resource.id);
    if (!mounted) return;

    // back to list, signal "changed"
    context.pop<bool>(true);
  }

  Future<void> _openLink() async {
    final uri = Uri.tryParse(_link.text.trim());
    if (uri == null) return;

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004B87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(), // just go back
        ),
        title: Text(
          'Resource Details : ${widget.courseName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _field('Title', _title, enabled: _editing),
            const SizedBox(height: 12),
            _field('Description', _desc,
                enabled: _editing, maxLines: 4),
            const SizedBox(height: 12),
            _field('Link', _link, enabled: _editing),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openLink,
              style: _buttonStyle(),
              child: const Text('Open Link'),
            ),
            const SizedBox(height: 24),
            if (_editing)
              ElevatedButton(
                onPressed: _saveEdit,
                style: _buttonStyle(),
                child: const Text('Save'),
              )
            else
              ElevatedButton(
                onPressed: _delete,
                style: _buttonStyle(),
                child: const Text('Delete Resource'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController c, {
        bool enabled = false,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: c,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF004B87),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
  );
}
