// lib/features/resources/resources_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:su_learning_companion/common/models/resource.dart';
import 'package:su_learning_companion/common/repos/resources_repo.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:su_learning_companion/common/widgets/app_scaffold.dart';

class ResourcesListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ResourcesListScreen({
    Key? key,
    required this.courseId,
    this.courseName = 'Course Name',
  }) : super(key: key);

  @override
  State<ResourcesListScreen> createState() => _ResourcesListScreenState();
}

class _ResourcesListScreenState extends State<ResourcesListScreen> {
  late final ResourcesRepo _repo;
  bool _repoReady = false;

  List<Resource> _resources = [];
  bool _loading = true;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _repo = context.read<ResourcesRepo>();
      _repoReady = true;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _repo
          .getResourcesByCourse(widget.courseId)
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      setState(() => _resources = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _openAdd() async {
    final added = await context.push<bool>(
      '/courses/${widget.courseId}/resources/add',
      extra: {'courseName': widget.courseName},
    );

    if (added == true) {
      await _load();
    }
  }

  Future<void> _openDetails(Resource r) async {
    final changed = await context.push<bool>(
      '/courses/${widget.courseId}/resources/details',
      extra: {
        'courseName': widget.courseName,
        'resource': r,
      },
    );

    if (changed == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
          onPressed: () => context.go('/courses/detail/${widget.courseId}'),
        ),
        title: Text(
          'Resources: ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          // 📄 CONTENT
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Padding(
              padding: AppSpacing.screen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load resources:\n$_error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                      onPressed: _load,
                      child: const Text(
                        'Try again',
                        style: AppTextStyles.primaryButton,
                      ),
                    ),
                  ),
                ],
              ),
            )
                : _resources.isEmpty
                ? const Center(child: Text('No resources available'))
                : ListView.builder(
              padding: AppSpacing.screen,
              itemCount: _resources.length,
              itemBuilder: (_, i) {
                final r = _resources[i];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.gapMedium,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor:
                      AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _openDetails(r),
                    child: Text(
                      r.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.listButton,
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _openAdd,
                child: const Text(
                  '+ Add Resource',
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
