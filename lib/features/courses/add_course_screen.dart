// lib/features/courses/add_course_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:su_learning_companion/common/models/course.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:su_learning_companion/common/widgets/app_scaffold.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  bool _loading = true;
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCourses);
    _loadCoursesFromFirestore();
  }

  Future<void> _loadCoursesFromFirestore() async {
    setState(() => _loading = true);

    try {
      final snap = await FirebaseFirestore.instance
          .collection('courses')
          .orderBy('courseCode')
          .get();

      final courses = snap.docs.map((doc) {
        final data = doc.data();

        final code = (data['courseCode'] ?? '').toString();
        final name = (data['courseName'] ?? '').toString();
        final term = (data['semester'] ?? '').toString();
        final instructor = (data['instructor'] ?? '').toString();

        // ✅ createdAt (required)
        DateTime createdAt = DateTime.now();
        final rawCreatedAt = data['createdAt'];
        if (rawCreatedAt is Timestamp) createdAt = rawCreatedAt.toDate();

        // ✅ createdBy (required if your Course model requires it)
        // If your global catalog doesn't store createdBy, use a safe fallback.
        final createdBy = (data['createdBy'] ?? 'system').toString();

        return Course(
          id: doc.id,
          code: code,
          name: name,
          term: term,
          instructor: instructor.isEmpty ? null : instructor,
          createdAt: createdAt,
          createdBy: createdBy, // ✅ ADDED
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _allCourses = courses;
        _filteredCourses = courses;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load courses: $e')),
      );
    }
  }

  void _filterCourses() {
    final q = _searchController.text.trim().toLowerCase();

    setState(() {
      if (q.isEmpty) {
        _filteredCourses = _allCourses;
        return;
      }

      _filteredCourses = _allCourses.where((c) {
        final name = c.name.toLowerCase();
        final code = c.code.toLowerCase();
        final instructor = (c.instructor ?? '').toLowerCase();
        return name.contains(q) || code.contains(q) || instructor.contains(q);
      }).toList();
    });
  }

  Future<void> _addCourseToUser(Course course) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must login first.')),
      );
      return;
    }

    try {
      final uid = user.uid;
      final courseId = course.id;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('courses')
          .doc(courseId)
          .set({
        'courseId': courseId,
        'courseCode': course.code,
        'courseName': course.name,
        'semester': course.term,
        'instructor': course.instructor,

        // ✅ REQUIRED FIELDS (ownership + timestamp)
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),

        // keep old field
        'addedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${course.code} added'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add course: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: const Text('Add Course', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textOnPrimary, size: 20),
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
                hintText: 'Search course name, code, instructor...',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
                prefixIcon:
                const Icon(Icons.search, color: AppColors.primaryBlue),
                filled: true,
                fillColor: const Color(0xFFE8F0F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: AppSpacing.gapMedium),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredCourses.isEmpty
                  ? Center(
                child: Text(
                  'No courses found',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
              )
                  : Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(12),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredCourses.length,
                  itemBuilder: (context, i) =>
                      _buildCourseCard(_filteredCourses[i]),
                ),
              ),
            ),
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
                  if ((course.instructor ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            course.instructor!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _addCourseToUser(course),
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
