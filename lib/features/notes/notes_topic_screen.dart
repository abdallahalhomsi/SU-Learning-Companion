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
  final _notesRepo = FirestoreNotesRepo();

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  bool _isEditing = false;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.note.title);
    _contentController =
        TextEditingController(text: widget.note.content);

    _titleController.addListener(_markDirty);
    _contentController.addListener(_markDirty);
  }

  void _markDirty() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<bool> _confirmExit() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unsaved changes'),
        content:
        const Text('Discard changes and leave?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    await _notesRepo.updateNote(
      courseId: widget.note.courseId,
      noteId: widget.note.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );

    setState(() {
      _isSaving = false;
      _isEditing = false;
      _hasUnsavedChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Stack(
        children: [
          AppScaffold(
            currentIndex: 0,
            appBar: AppBar(
              backgroundColor: AppColors.primaryBlue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: AppColors.textOnPrimary,
                    size: 20),
                onPressed: () async {
                  if (await _confirmExit()) {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(widget.courseName,
                  style: AppTextStyles.appBarTitle),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: AppSpacing.screen,
                  child: TextField(
                    controller: _titleController,
                    readOnly: !_isEditing,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    decoration:
                    const InputDecoration(border: InputBorder.none),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: AppSpacing.screen,
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      readOnly: !_isEditing,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primaryBlue,
                        foregroundColor:
                        AppColors.textOnPrimary,
                      ),
                      onPressed:
                      _isEditing ? _save : () {
                        setState(() => _isEditing = true);
                      },
                      child: Text(
                        _isEditing ? 'Save Note' : 'Edit Note',
                        style: AppTextStyles.primaryButton,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // added loading overlay while screen saves new changes to notees
          if (_isSaving)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                    color: Colors.white),
              ),
            ),
        ],
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
