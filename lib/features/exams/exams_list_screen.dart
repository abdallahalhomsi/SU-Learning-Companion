import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/date_time_formatter.dart';
import '../../common/models/exam.dart';
import '../../common/repos/exams_repo.dart';
import '../../data/fakes/fake_exams_repo.dart';

class ExamsListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ExamsListScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<ExamsListScreen> createState() => _ExamsListScreenState();
}

class _ExamsListScreenState extends State<ExamsListScreen> {
  final ExamsRepo _examsRepo = FakeExamsRepo();

  List<Exam> _exams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  void _loadExams() {
    // Repo is synchronous, so we can just read and set synchronously
    final items = _examsRepo.getExamsForCourse(widget.courseId);
    setState(() {
      _exams = items;
      _isLoading = false;
    });
  }
  void _removeExam(String examId) {
    _examsRepo.removeExam(examId);
    _loadExams(); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            context.go('/courses/detail/${widget.courseId}');
          },
        ),
        title: Text(
          'Exams: ${widget.courseName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _exams.isEmpty
                      ? const Center(child: Text('No exams yet'))
                      : ListView.separated(
                    itemCount: _exams.length,
                    itemBuilder: (context, index) {
                      final exam = _exams[index];

                      final formattedDate =
                      DateTimeFormatter.formatRawDate(exam.date);
                      final formattedTime =
                      DateTimeFormatter.formatRawTime(exam.time);

                      return Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF003366),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TEXT
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                '${exam.title}: $formattedDate, $formattedTime',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // DELETE BUTTON
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                _removeExam(exam.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(
                      '/courses/${widget.courseId}/exams/add',
                      extra: {'courseName': widget.courseName},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    '+ Add Exam',
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
      ),
    );
  }
}