// lib/features/notes/notes_topic_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/models/notes.dart';
import '../../common/repos/notes_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

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
  late final NotesRepo _notesRepo;

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool _isEditing = false;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notesRepo = context.read<NotesRepo>();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);

    _titleController.addListener(_markDirty);
    _contentController.addListener(_markDirty);
  }

  void _markDirty() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _confirmDiscard() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Unsaved changes',
                style: TextStyle(color: Colors.red)),
          ],
        ),
        content: const Text(
          'You have unsaved changes.\nDo you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Discard',
              style: TextStyle(color: Colors.red),
            ),
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

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _isEditing = false;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Note saved successfully',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscard();
        if (shouldPop && mounted) {
          Navigator.pop(context, result);
        }
      },
      child: AppScaffold(
        currentIndex: 0,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          centerTitle: true,
          title: Text(widget.courseName,
              style: AppTextStyles.appBarTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColors.textOnPrimary),
            onPressed: () async {
              final shouldPop = await _confirmDiscard();
              if (shouldPop && mounted) Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: AppSpacing.screen,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5EAF1)),
                ),
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: _LinedPaperPainter(
                        lineColor: const Color(0xFFCBD5E1),
                        spacing: 28,
                        topOffset: 60,
                      ),
                      size: Size.infinite,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            readOnly: !_isEditing,
                            style: AppTextStyles.primaryButton.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _contentController,
                              readOnly: !_isEditing,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Write your notes...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isSaving)
              Container(
                color: Colors.black.withValues(alpha: 0.25),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryBlue,
          onPressed: _isSaving
              ? null
              : () => _isEditing ? _save() : setState(() => _isEditing = true),
          child: Icon(
            _isEditing ? Icons.save : Icons.edit,
            color: Colors.white,
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

  const _LinedPaperPainter({
    required this.lineColor,
    required this.spacing,
    required this.topOffset,
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
  bool shouldRepaint(_) => false;
}
