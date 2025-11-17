import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';

class FlashcardFormSheetQuestion extends StatefulWidget {
  const FlashcardFormSheetQuestion({super.key});

  @override
  State<FlashcardFormSheetQuestion> createState() =>
      _FlashcardFormSheetQuestionState();
}

class _FlashcardFormSheetQuestionState
    extends State<FlashcardFormSheetQuestion> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String? _selectedDifficulty;

  @override
  void dispose() {
    _titleController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _submit() {
    final titleText = _titleController.text.trim();
    final questionText = _questionController.text.trim();
    final answerText = _answerController.text.trim();

    if (questionText.isEmpty || answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in question and answer')),
      );
      return;
    }

    final cardTitle =
    titleText.isEmpty ? questionText : titleText; // what shows on card

    Navigator.of(context).pop(<String, String>{
      'title': cardTitle,
      'solution': answerText,
      // difficulty is optional for now
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Flash Card:',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _InputBox(
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InputBox(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Select Difficulty'),
                            value: _selectedDifficulty,
                            items: const [
                              DropdownMenuItem(
                                value: 'Easy',
                                child: Text('Easy'),
                              ),
                              DropdownMenuItem(
                                value: 'Medium',
                                child: Text('Medium'),
                              ),
                              DropdownMenuItem(
                                value: 'Hard',
                                child: Text('Hard'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDifficulty = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InputBox(
                        child: TextField(
                          controller: _questionController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Question 1...',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InputBox(
                        child: TextField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Answer 1...',
                          ),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '+ Add more',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final Widget child;

  const _InputBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
