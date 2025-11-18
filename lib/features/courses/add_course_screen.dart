// This file makes up the components of the Add Course screen where users can search
// for courses and add them to their list.
// It includes a search bar and allows users to view search results.(no database integration yet)
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../common/widgets/app_scaffold.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final CoursesRepo _coursesRepo = FakeCoursesRepo();
  final TextEditingController _searchController = TextEditingController();
  List<Course> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCourses() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a search term'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final courses = await _coursesRepo.searchCourses(query);
      setState(() {
        _searchResults = courses;
        _isLoading = false;
      });

      if (mounted) {
        _showResultsDrawer();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    }
  }

  void _showResultsDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Results (${_searchResults.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        'No courses found',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, i) =>
                          _buildCourseCard(_searchResults[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCourse(Course course) async {
    await _coursesRepo.addCourse(course);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${course.name} added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0, 

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: const Text(
          'Add Course',
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
          onPressed: () => context.go('/home'),
        ),
      ),

      body: Padding(
        padding: AppSpacing.screen,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search Course...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryBlue,
                ),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.primaryBlue,
                        ),
                        onPressed: _searchCourses,
                      ),
                filled: true,
                fillColor: const Color(0xFFE8F0F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              onSubmitted: (_) => _searchCourses(),
            ),

            const Spacer(),

            Text(
              'Enter course name or code to search',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppSpacing.gapMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: AppSpacing.card,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.code,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.term,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  if (course.instructor != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          course.instructor!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            
            ElevatedButton(
              onPressed: () => _addCourse(course),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
