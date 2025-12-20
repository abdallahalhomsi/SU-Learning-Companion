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

  late String _savedTitle;
  late String _savedContent;

  bool get _hasUnsavedChanges =>
      _titleController.text.trim() != _savedTitle ||
          _contentController.text.trim() != _savedContent;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _paperBg => _isDark ? const Color(0xFF0B1220) : AppColors.cardBackground;
  Color get _border => _isDark ? const Color(0xFF1F2937) : const Color(0xFFE5EAF1);
  Color get _lineColor => _isDark ? const Color(0xFF243244) : const Color(0xFFCBD5E1);

  Color get _text => _isDark ? Colors.white : Colors.black;
  Color get _hint => _isDark ? Colors.white70 : Colors.black54;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notesRepo = context.read<NotesRepo>();
  }

  @override
  void initState() {
    super.initState();

    _savedTitle = widget.note.title.trim();
    _savedContent = widget.note.content.trim();

    _titleController = TextEditingController(text: _savedTitle);
    _contentController = TextEditingController(text: _savedContent);

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_isEditing) return;
    setState(() {});
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
            Text('Unsaved changes', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: const Text('You have unsaved changes.\nDo you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final newTitle = _titleController.text.trim();
    final newContent = _contentController.text.trim();

    await _notesRepo.updateNote(
      courseId: widget.note.courseId,
      noteId: widget.note.id,
      title: newTitle,
      content: newContent,
    );

    if (!mounted) return;

    _savedTitle = newTitle;
    _savedContent = newContent;

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Note saved successfully', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _handleBack() async {
    if (!_hasUnsavedChanges) {
      Navigator.pop(context);
      return;
    }

    final shouldPop = await _confirmDiscard();
    if (shouldPop && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (!_hasUnsavedChanges) {
          if (mounted) Navigator.pop(context, result);
          return;
        }

        final shouldPop = await _confirmDiscard();
        if (shouldPop && mounted) Navigator.pop(context, result);
      },
      child: AppScaffold(
        currentIndex: 0,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          centerTitle: true,
          title: Text(widget.courseName, style: AppTextStyles.appBarTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary),
            onPressed: _handleBack,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: AppSpacing.screen,
              child: Container(
                decoration: BoxDecoration(
                  color: _paperBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: _LinedPaperPainter(
                        lineColor: _lineColor,
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
                            style: TextStyle(
                              color: _text,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            cursorColor: _text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              hintStyle: TextStyle(color: _hint),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _contentController,
                              readOnly: !_isEditing,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: _text, height: 1.4),
                              cursorColor: _text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Write your notes...',
                                hintStyle: TextStyle(color: _hint),
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
              : () {
            if (_isEditing) {
              _save();
            } else {
              setState(() => _isEditing = true);
            }
          },
          child: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
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
      canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), paint);
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
