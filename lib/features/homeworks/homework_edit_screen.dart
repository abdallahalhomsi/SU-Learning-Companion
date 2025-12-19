// lib/features/homeworks/homework_edit_screen.dart
//
// Dark-mode-safe: input bg + text/hint/cursor adapt to theme.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/models/homework.dart';
import '../../common/repos/homeworks_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_spacing.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/widgets/app_scaffold.dart';

class HomeworkEditScreen extends StatefulWidget {
  final String courseName;
  final Homework homework;

  const HomeworkEditScreen({
    super.key,
    required this.courseName,
    required this.homework,
  });

  @override
  State<HomeworkEditScreen> createState() => _HomeworkEditScreenState();
}

class _HomeworkEditScreenState extends State<HomeworkEditScreen> {
  late final HomeworksRepo _repo;

  late final TextEditingController _title;
  late final TextEditingController _date;
  late final TextEditingController _time;

  bool _editing = false;
  bool _saving = false;

  late String _savedTitle;
  late String _savedDate;
  late String _savedTime;

  bool get _dirty =>
      _title.text.trim() != _savedTitle ||
          _date.text.trim() != _savedDate ||
          _time.text.trim() != _savedTime;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _fieldBg => _isDark ? const Color(0xFF111827) : AppColors.inputGrey;
  Color get _fieldText => _isDark ? Colors.white : Colors.black;
  Color get _hintText => _isDark ? Colors.white70 : Colors.black54;
  Color get _borderColor => _isDark ? const Color(0xFF334155) : Colors.transparent;

  @override
  void initState() {
    super.initState();
    _savedTitle = widget.homework.title.trim();
    _savedDate = widget.homework.date.trim();
    _savedTime = widget.homework.time.trim();

    _title = TextEditingController(text: _savedTitle);
    _date = TextEditingController(text: _savedDate);
    _time = TextEditingController(text: _savedTime);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repo = context.read<HomeworksRepo>();
  }

  @override
  void dispose() {
    _title.dispose();
    _date.dispose();
    _time.dispose();
    super.dispose();
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty) return true;
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Unsaved changes'),
        content: const Text('Discard your changes?'),
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
    setState(() => _saving = true);
    try {
      final updated = Homework(
        id: widget.homework.id,
        courseId: widget.homework.courseId,
        title: _title.text.trim(),
        date: _date.text.trim(),
        time: _time.text.trim(),
      );

      await _repo.updateHomework(updated);

      _savedTitle = updated.title.trim();
      _savedDate = updated.date.trim();
      _savedTime = updated.time.trim();

      if (!mounted) return;
      setState(() {
        _saving = false;
        _editing = false;
      });

      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save homework: $e')),
      );
    }
  }

  Future<void> _delete() async {
    setState(() => _saving = true);
    try {
      await _repo.removeHomework(widget.homework.courseId, widget.homework.id);
      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete homework: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final ok = await _confirmDiscard();
        if (ok && mounted) Navigator.pop(context, result);
      },
      child: AppScaffold(
        currentIndex: 0,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          title: Text('Homework: ${widget.courseName}', style: AppTextStyles.appBarTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary, size: 20),
            onPressed: () async {
              final ok = await _confirmDiscard();
              if (ok && mounted) Navigator.pop(context);
            },
          ),
          actions: [
            if (!_editing)
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.textOnPrimary),
                onPressed: () => setState(() => _editing = true),
              ),
          ],
        ),
        body: _saving
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: AppSpacing.screen,
          child: Column(
            children: [
              _field(_title, hint: 'Title', enabled: _editing),
              const SizedBox(height: AppSpacing.gapSmall),
              _field(_date, hint: 'Date', enabled: _editing),
              const SizedBox(height: AppSpacing.gapSmall),
              _field(_time, hint: 'Time', enabled: _editing),
              const SizedBox(height: AppSpacing.gapMedium),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _editing ? AppColors.primaryBlue : Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: _editing ? _save : _delete,
                  child: Text(
                    _editing ? 'Save' : 'Delete Homework',
                    style: AppTextStyles.primaryButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController c, {
        required String hint,
        required bool enabled,
      }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _borderColor),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: c,
        readOnly: !enabled,
        style: TextStyle(color: _fieldText),
        cursorColor: _fieldText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: _hintText),
        ),
      ),
    );
  }
}
