import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/repos/courses_repo.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.read<CoursesRepo>();
    return StreamBuilder(
      stream: repo.watchAll(),
      builder: (context, snap) {
        final items = snap.data ?? const [];
        return Scaffold(
          appBar: AppBar(title: const Text('Courses')),
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ListTile(
              title: Text('${items[i].code} — ${items[i].name}'),
              subtitle: Text(items[i].term),
            ),
          ),
        );
      },
    );
  }
}


/// Courses UI (list).
/// - Reads data via CoursesRepo (injected).
/// Future: add add/edit forms and course detail tabs.