import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/utils/date_time_formatter.dart';
import '../../common/models/homework.dart';
import '../../common/repos/homeworks_repo.dart';
import '../../data/fakes/fake_homeworks_repo.dart';
import '../../common/widgets/app_scaffold.dart';

class HomeworksListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const HomeworksListScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<HomeworksListScreen> createState() => _HomeworksListScreenState();
}

class _HomeworksListScreenState extends State<HomeworksListScreen> {
  final HomeworksRepo _homeworksRepo = FakeHomeworksRepo();

  void _removeHomework(String hwId) {
    setState(() {
      _homeworksRepo.removeHomework(hwId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Homework> homeworks =
    _homeworksRepo.getHomeworksForCourse(widget.courseId);

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white, size: 20),
          onPressed: () {
            context.go('/courses/detail/${widget.courseId}');
          },
        ),
        title: Text(
          'Homeworks: ${widget.courseName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: homeworks.isEmpty
                    ? const Center(
                  child: Text(
                    'No homeworks yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : ListView.separated(
                  itemCount: homeworks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final hw = homeworks[index];

                    return Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF003366),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              '${hw.title}: '
                                  '${DateTimeFormatter.formatRawDate(hw.date)}, '
                                  '${DateTimeFormatter.formatRawTime(hw.time)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () => _removeHomework(hw.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  context.go(
                    '/courses/${widget.courseId}/homeworks/add',
                    extra: {'courseName': widget.courseName},
                  );
                },
                child: const Text(
                  '+ Add Homework',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}