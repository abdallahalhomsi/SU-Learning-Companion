import 'package:flutter/material.dart';

class NotesTopicScreen extends StatelessWidget {
  final String courseName;
  final String topicName;

  const NotesTopicScreen({
    super.key,
    required this.courseName,
    required this.topicName,
  });

  static const _barBlue = Color(0xFF155FA0);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: 'Here are my notes for $topicName...',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: _barBlue,
        title: Text('$courseName: $topicName'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
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
              // Lined paper background
              CustomPaint(
                painter: _LinedPaperPainter(
                  lineColor: const Color(0xFFCBD5E1),
                  spacing: 28,
                  topOffset: 32,
                ),
                size: Size.infinite,
              ),

              // Text on top
              TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  height: 1.4, // spreads lines a bit
                ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
