import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/repos/tasks_repo.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.read<TasksRepo>();
    return StreamBuilder(
      stream: repo.watchAll(),
      builder: (context, snap) {
        final items = snap.data ?? const [];
        return Scaffold(
          appBar: AppBar(title: const Text('Tasks')),
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(items[i].title),
              subtitle: Text(items[i].dueAt.toIso8601String()),
            ),
          ),
        );
      },
    );
  }
}

/// Tasks UI (list).
/// - Reads data via TasksRepo (injected).
/// Future: add filters, add/edit, reminders hook.