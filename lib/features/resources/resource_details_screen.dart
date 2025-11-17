// resource_details_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/resource.dart';
import '../repositories/resources_repo.dart';

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

    setState(() {
      _editing = false;
      _loading = false;
    });

    Navigator.pop(context, true);
  }

  Future<void> _delete() async {
    await _repo.deleteResource(widget.resource.id);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resource Details : ${widget.courseName}"),
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
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
                  _field("Title", _title, enabled: _editing),
                  const SizedBox(height: 12),
                  _field("Description", _desc, enabled: _editing, maxLines: 4),
                  const SizedBox(height: 12),
                  _field("Link", _link, enabled: _editing),
                  const SizedBox(height: 20),

                  if (_editing)
                    ElevatedButton(
                      onPressed: _saveEdit,
                      style: _btn(),
                      child: const Text("Save"),
                    ),

                  if (!_editing)
                    ElevatedButton(
                      onPressed: _delete,
                      style: _btn(),
                      child: const Text("Delete Resource"),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _field(String label, TextEditingController c,
      {bool enabled = false, int maxLines = 1}) {
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

  ButtonStyle _btn() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      );
}
