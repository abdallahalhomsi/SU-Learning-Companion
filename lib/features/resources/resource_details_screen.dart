// lib/features/resources/resource_details_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../common/models/resource.dart';
import '../../common/repos/resources_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

/// Displays the details of a specific resource and allows the creator to edit or delete it.
class ResourceDetailsScreen extends StatefulWidget {
  final Resource resource;
  final String courseId;
  final String courseName;

  const ResourceDetailsScreen({
    super.key,
    required this.resource,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  late final ResourcesRepo _repo;

  // UI State
  bool _editing = false;
  bool _loading = false;

  late TextEditingController _title;
  late TextEditingController _desc;
  late TextEditingController _link;

  /// Verifies if the current logged-in user matches the resource's creator.
  /// This determines visibility for 'Edit' and 'Delete' actions.
  bool get _isOwner {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == widget.resource.createdBy;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repo = context.read<ResourcesRepo>();
  }

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.resource.title);
    _desc = TextEditingController(text: widget.resource.description);
    _link = TextEditingController(text: widget.resource.link);
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _link.dispose();
    super.dispose();
  }

  /// Persists changes to Firestore.
  /// Preserves the original [createdBy] field to maintain ownership.
  Future<void> _saveEdit() async {
    setState(() => _loading = true);

    try {
      final updated = Resource(
        id: widget.resource.id,
        courseId: widget.resource.courseId,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        link: _link.text.trim(),
        createdBy: widget.resource.createdBy,
        createdAt: widget.resource.createdAt,
      );

      await _repo.updateResource(updated);

      if (!mounted) return;
      setState(() {
        _loading = false;
        _editing = false;
      });
      context.pop<bool>(true); // Return true to trigger a list refresh
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  Future<void> _delete() async {
    try {
      await _repo.deleteResource(widget.courseId, widget.resource.id);
      if (!mounted) return;
      context.pop<bool>(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  /// Launches the resource URL in an external browser.
  /// Automatically prefixes 'https://' if the user omitted the protocol.
  Future<void> _openLink() async {
    String urlText = _link.text.trim();
    if (urlText.isEmpty) return;

    if (!urlText.startsWith('http://') && !urlText.startsWith('https://')) {
      urlText = 'https://$urlText';
    }

    final uri = Uri.tryParse(urlText);
    if (uri == null) {
      _showSnack('Invalid URL format');
      return;
    }

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('Could not open link');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          'Resource: ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        actions: [
          if (!_editing && _isOwner)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.textOnPrimary),
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: AppSpacing.screen,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _field('Title', _title, enabled: _editing),
              const SizedBox(height: AppSpacing.gapMedium),
              _field('Description', _desc, enabled: _editing, maxLines: 4),
              const SizedBox(height: AppSpacing.gapMedium),
              _field('Link', _link, enabled: _editing),
              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _openLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Open Link', style: AppTextStyles.primaryButton),
                ),
              ),
              const SizedBox(height: 16),

              if (_isOwner)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _editing ? _saveEdit : _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _editing ? AppColors.primaryBlue : AppColors.errorRed,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _editing ? 'Save' : 'Delete Resource',
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

  Widget _field(String label, TextEditingController c, {bool enabled = false, int maxLines = 1}) {
    return TextFormField(
      controller: c,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}