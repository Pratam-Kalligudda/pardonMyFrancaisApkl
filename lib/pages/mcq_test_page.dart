// pages/mcq_test_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/widgets/mcq_option.dart';

class MCQTestPage extends StatefulWidget {
  final String lessonName;
  final String levelName; 

  const MCQTestPage({Key? key, required this.lessonName, required this.levelName,}) : super(key: key);

  @override
  _MCQTestPageState createState() => _MCQTestPageState();
}

class _MCQTestPageState extends State<MCQTestPage> {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> mcqData = [
    {
      'question': 'Question 1',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'correctIndex': 1, // Index of the correct option
    },
    {
      'question': 'Question 2',
      'options': ['Option A', 'Option B', 'Option C', 'Option D'],
      'correctIndex': 2, // Index of the correct option
    },
  ];
  List<int> selectedOptions = List.filled(4, -1); // Assuming 4 options per question

  void selectOption(int index) {
    setState(() {
      selectedOptions[currentQuestionIndex] = index;
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex >= mcqData.length) {
        _showNextTestConfirmationDialog();
      }
    });
  }

  Future<void> _showNextTestConfirmationDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text(
          'Move to Next Test?',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: const Text(
          'Do you want to move to the next test?',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform the action to move to the next test
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform any other action you want here
            },
            child: const Text(
              'No',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String levelName = args['levelName'] as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('$levelName MCQ Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Multiple Choice Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Select the correct option for the question from the given options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              mcqData[currentQuestionIndex]['question'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              mcqData[currentQuestionIndex]['options'].length,
              (index) => Column(
                children: [
                  MCQOption(
                    option: mcqData[currentQuestionIndex]['options'][index],
                    isSelected: selectedOptions[currentQuestionIndex] == index,
                    onTap: () {
                      selectOption(index);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedOptions[currentQuestionIndex] != -1) {
                  if (currentQuestionIndex < mcqData.length - 1) {
                    nextQuestion();
                  } else {
                    _showNextTestConfirmationDialog();
                  }
                } else {
                  // Show a message indicating the user to select an option
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an option'),
                    ),
                  );
                }
              },
               style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                currentQuestionIndex < mcqData.length - 1 ? 'Next' : 'Submit',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
