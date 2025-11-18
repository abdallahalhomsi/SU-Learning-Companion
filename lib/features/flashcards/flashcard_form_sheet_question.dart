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
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String? _selectedDifficulty;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _submit() {
    bool formValid = _formKey.currentState!.validate();
    bool difficultyValid = true;

    if (!formValid || !difficultyValid) {
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


    Navigator.of(context).pop(<String, String>{
      'question': _questionController.text.trim(),
      'solution': _answerController.text.trim(),
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [


                        // Question Field
                        _buildFieldWrapper(
                          height: 80,
                          child: TextFormField(
                            controller: _questionController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Question',
                              errorStyle: TextStyle(fontSize: 11, height: 1.1),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Question is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Difficulty Dropdown
                        _buildFieldWrapper(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('Select Difficulty'),
                              value: _selectedDifficulty,
                              items: const [
                                DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                DropdownMenuItem(value: 'Hard', child: Text('Hard')),
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

                        // Answer Field
                        _buildFieldWrapper(
                          height: 100,
                          child: TextFormField(
                            controller: _answerController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Answer...',
                              errorStyle: TextStyle(fontSize: 11, height: 1.1),
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Answer is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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

  Widget _buildFieldWrapper({required Widget child, double height = 44}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}