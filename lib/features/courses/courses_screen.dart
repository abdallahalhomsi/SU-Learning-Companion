import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../common/widgets/app_scaffold.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CoursesRepo _coursesRepo = FakeCoursesRepo();
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      final courses = await _coursesRepo.getCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading courses: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text(
          'My Courses',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No courses yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/courses/add').then((_) => _loadCourses());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadCourses,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return _buildCourseCard(course);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/courses/add').then((_) => _loadCourses());
        },
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add),
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
            // Already on home
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

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push('/courses/detail/${course.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003366),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                course.code,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                course.term,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
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
                    const SizedBox(width: 4),
                    Text(
                      course.instructor!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}