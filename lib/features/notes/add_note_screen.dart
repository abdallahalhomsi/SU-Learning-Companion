import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  final String courseName;
  const AddNoteScreen({super.key, required this.courseName});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  static const _barBlue = Color(0xFF155FA0);

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: _barBlue,
        title: const Text('Add Note'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Title field
                TextField(
                  controller: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    fillColor: const Color(0xFFF2F4F7),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Lined note area
                Container(
                  height: 420,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                    Border.all(color: const Color(0xFFE5EAF1)),
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
                        controller: _body,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                          height: 1.4,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Write your note...',
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.fromLTRB(16, 10, 16, 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Full-width blue Submit bar
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _barBlue,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                // TODO: save note somewhere
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
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
