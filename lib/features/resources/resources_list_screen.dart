// This file makes up the components of the Resources List Screen,
// Which displays a list of resources for a specific course.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/models/resource.dart';
import '../../common/repos/resources_repo.dart';
import '../../data/fakes/fake_resources_repo.dart';

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
  final ResourcesRepo _repo = FakeResourcesRepo();

  List<Resource> _resources = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.getResourcesByCourse(widget.courseId);
    setState(() {
      _resources = list;
      _loading = false;
    });
  }

  Future<void> _openAdd() async {
    final added = await context.push<bool>(
      '/courses/${widget.courseId}/resources/add',
      extra: {'courseName': widget.courseName},
    );

    if (added == true) _load();
  }

  Future<void> _openDetails(Resource r) async {
    final changed = await context.push<bool>(
      '/courses/${widget.courseId}/resources/details',
      extra: {
        'courseName': widget.courseName,
        'resource': r,
      },
    );

    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textOnPrimary, size: 20),
          onPressed: () {
            context.go('/courses/detail/${widget.courseId}');
          },
        ),
        title: Text(
          'Resources: ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _resources.isEmpty
              ? Center(
                  child: Text(
                    'No resources available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                )
              : ListView.builder(
                  padding: AppSpacing.screen,
                  itemCount: _resources.length,
                  itemBuilder: (_, i) {
                    final r = _resources[i];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.gapMedium),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _openDetails(r),
                        child: Text(
                          r.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
