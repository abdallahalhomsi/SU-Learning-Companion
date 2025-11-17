// resources_list_screen.dart
import 'package:flutter/material.dart';
import 'add_resource_screen.dart';
import 'resource_details_screen.dart';
import '../models/resource.dart';
import '../repositories/resources_repo.dart';

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
    final added = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddResourceScreen(
          courseId: widget.courseId,
          courseName: widget.courseName,
        ),
      ),
    );

    if (added == true) _load();
  }

  Future<void> _openDetails(Resource r) async {
    final changed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResourceDetailsScreen(
          resource: r,
          courseId: widget.courseId,
          courseName: widget.courseName,
        ),
      ),
    );

    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resources : ${widget.courseName}"),
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _resources.isEmpty
              ? const Center(child: Text("No resources available"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _resources.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004B87),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => _openDetails(_resources[i]),
                        child: Text(_resources[i].title),
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
