import 'package:flutter/material.dart';
import 'notes_topic_screen.dart';
import 'add_note_screen.dart';

class NotesListScreen extends StatelessWidget {
  final String courseName;
  const NotesListScreen({super.key, required this.courseName});

  static const _barBlue = Color(0xFF155FA0);

  @override
  Widget build(BuildContext context) {
    final topics = const ['Topic 1', 'Topic 2', 'Topic 3'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: _barBlue,
        title: Text('Notes : $courseName'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // white card with topics
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5EAF1)),
                ),
                padding: const EdgeInsets.all(12),
                child: ListView.separated(
                  itemCount: topics.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    return SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _barBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NotesTopicScreen(
                                courseName: courseName,
                                topicName: topics[i],
                              ),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(topics[i]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // clearly visible add note button (above bottom nav)
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _barBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddNoteScreen(courseName: courseName),
                    ),
                  );
                },
                child: const Text('+ Add Note'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        selectedItemColor: _barBlue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
