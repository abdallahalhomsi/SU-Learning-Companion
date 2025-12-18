// This file makes up the components of the Notes Topic Screen,
// Which displays the specific written notes of the user.
// Uses Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.

import 'package:flutter/material.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/models/notes.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';
import '../../common/repos/firestore_notes_repo.dart';

class NotesTopicScreen extends StatefulWidget {
  final String courseName;
  final Note note;

  const NotesTopicScreen({
    super.key,
    required this.courseName,
    required this.note,
  });

  @override
  State<NotesTopicScreen> createState() => _NotesTopicScreenState();
}

class _NotesTopicScreenState extends State<NotesTopicScreen> {
  late TextEditingController _controller;
  bool _isEditing = false;
  final _notesRepo = FirestoreNotesRepo();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_controller.text.trim().isEmpty) {
      _showAlert('Note cannot be empty.');
      return;
    }

    try {
      await _notesRepo.updateNote(
        courseId: widget.note.courseId,
        noteId: widget.note.id,
        content: _controller.text.trim(),
      );

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved successfully')),
      );
    } catch (e) {
      _showAlert('Failed to save note. Please try again.');
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: Text(
          '${widget.courseName}: ${widget.note.title}',
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.screen,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5EAF1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: LinedPaperPainter(
                  lineColor: const Color(0xFFCBD5E1),
                  spacing: 28,
                  topOffset: 32,
                ),
                size: Size.infinite,
              ),
              TextField(
                controller: _controller,
                maxLines: null,
                readOnly: !_isEditing,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  height: 1.4,
                  color: AppColors.textPrimary,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        child: Icon(
          _isEditing ? Icons.save : Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          if (_isEditing) {
            _saveNote();
          } else {
            setState(() => _isEditing = true);
          }
        },
      ),
    );
  }
}

// added painter class for lined pages
class LinedPaperPainter extends CustomPainter {
  final Color lineColor;
  final double spacing;
  final double topOffset;

  LinedPaperPainter({
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
