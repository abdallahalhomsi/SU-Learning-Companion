// lib/features/resources/resources_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    if (added == true) {
      _load();
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
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004B87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            context.go('/courses/detail/${widget.courseId}');
          },
        ),
        title: Text(
          'Resources : ${widget.courseName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _resources.isEmpty
          ? const Center(child: Text('No resources available'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _resources.length,
        itemBuilder: (_, i) {
          final r = _resources[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004B87),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _openDetails(r),
              child: Text(r.title),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
