import 'package:flutter/material.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/models/notes.dart';

class NotesTopicScreen extends StatelessWidget {
  final String courseName;
  final Note note;

  const NotesTopicScreen({
    super.key,
    required this.courseName,
    required this.note,
  });

  static const _barBlue = Color(0xFF003366);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: note.content);

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: _barBlue,
        title: Text(
          '$courseName: ${note.title}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5EAF1)),
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: _LinedPaperPainter(
                  lineColor: const Color(0xFFCBD5E1),
                  spacing: 28,
                  topOffset: 32,
                ),
                size: Size.infinite,
              ),
              TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(height: 1.4),
                decoration: const InputDecoration(
                  hintText: 'Write your notes...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinedPaperPainter extends CustomPainter {
  final Color lineColor;
  final double spacing;
  final double topOffset;

  _LinedPaperPainter({
    required this.lineColor,
    this.spacing = 28,
    this.topOffset = 32,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    double y = topOffset;
    while (y < size.height) {
      canvas.drawLine(
        Offset(12, y),
        Offset(size.width - 12, y),
        paint,
      );
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
