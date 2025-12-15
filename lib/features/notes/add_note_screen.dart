// lib/features/notes/add_note_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/models/notes.dart';
import '../../common/repos/notes_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class AddNoteScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const AddNoteScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  late final NotesRepo _notesRepo;
  bool _repoReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _notesRepo = context.read<NotesRepo>();
      _repoReady = true;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Please fix the form'),
          content: const Text(
            'Some fields are missing or invalid.\n'
                'Fields with red text need your attention.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: widget.courseId,
      title: _title.text.trim(),
      content: _body.text,
      createdAt: DateTime.now(),
    );

    try {
      await _notesRepo.addNote(note);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: Text(
          'Add Note - ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: AppSpacing.screen,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                      fillColor: AppColors.inputGrey.withOpacity(0.25),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.gapMedium),
                  Container(
                    height: 420,
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
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Write your note...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textOnPrimary,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: _submit,
              child: const Text('Submit', style: AppTextStyles.primaryButton),
            ),
          ),
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
    final paint = Paint()..color = lineColor..strokeWidth = 1;
    double y = topOffset;
    while (y < size.height) {
      canvas.drawLine(
        const Offset(12, 0) + Offset(0, y),
        Offset(size.width - 12, y),
        paint,
      );
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
