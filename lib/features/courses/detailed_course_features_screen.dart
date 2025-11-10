import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../common/widgets/app_scaffold.dart';

class DetailedCourseFeaturesScreen extends StatefulWidget {
  final String courseId;

  const DetailedCourseFeaturesScreen({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<DetailedCourseFeaturesScreen> createState() =>
      _DetailedCourseFeaturesScreenState();
}

class _DetailedCourseFeaturesScreenState
    extends State<DetailedCourseFeaturesScreen> {
  final CoursesRepo _coursesRepo = FakeCoursesRepo();
  Course? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    setState(() => _isLoading = true);
    final course = await _coursesRepo.getCourseById(widget.courseId);
    setState(() {
      _course = course;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _course?.name ?? 'Course Name',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _course == null
          ? const Center(child: Text('Course not found'))
          : Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFeatureButton(
                icon: Icons.note,
                label: 'Notes',
                onTap: () => _showFeatureDialog('Notes'),
              ),
              const SizedBox(height: 30),
              _buildFeatureButton(
                icon: Icons.folder,
                label: 'Resources',
                onTap: () => _showFeatureDialog('Resources'),
              ),
              const SizedBox(height: 30),
              _buildFeatureButton(
                icon: Icons.style,
                label: 'Flashcards',
                onTap: () => _showFeatureDialog('Flashcards'),
              ),
              const SizedBox(height: 30),
              _buildFeatureButton(
                icon: Icons.assignment,
                label: 'Homeworks',
                onTap: () => _showFeatureDialog('Homeworks'),
              ),
              const SizedBox(height: 30),
              _buildFeatureButton(
                icon: Icons.quiz,
                label: 'Exams',
                onTap: () => _showFeatureDialog('Exams'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: const Color(0xFF003366),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF003366),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature feature for ${_course?.name}\n\nComing soon!'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}