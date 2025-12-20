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

  bool _editing = false;
  bool _loading = false;

  late TextEditingController _title;
  late TextEditingController _desc;
  late TextEditingController _link;

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
      context.pop<bool>(true);
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

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
    } catch (_) {
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
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textOnPrimary, size: 20),
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
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _field('Title', _title, readOnly: !_editing),
              const SizedBox(height: AppSpacing.gapMedium),
              _field('Description', _desc,
                  readOnly: !_editing, maxLines: 4),
              const SizedBox(height: AppSpacing.gapMedium),
              _field('Link', _link, readOnly: !_editing),
              const SizedBox(height: 20),

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
                  child: const Text('Open Link',
                      style: AppTextStyles.primaryButton),
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
                      backgroundColor: _editing
                          ? AppColors.primaryBlue
                          : AppColors.errorRed,
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

  Widget _field(
      String label,
      TextEditingController c, {
        required bool readOnly,
        int maxLines = 1,
      }) {
    const textColor = AppColors.textPrimary; // explicit to avoid white-on-white
    final fill = Colors.white;
    final borderColor = const Color(0xFFE0E0E0);

    return TextFormField(
      controller: c,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(
        color: textColor,
        fontSize: 14,
      ),
      cursorColor: AppColors.primaryBlue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        floatingLabelStyle: const TextStyle(color: AppColors.primaryBlue),
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: fill,

        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),


      ),
    );
  }
}
