import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:french_app/models/sublevel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MCQTestPage extends StatefulWidget {
  final String lessonName;
  final String levelName;

  const MCQTestPage({
    Key? key,
    required this.lessonName,
    required this.levelName,
  }) : super(key: key);

  @override
  State<MCQTestPage> createState() => _MCQTestPageState();
}

class _MCQTestPageState extends State<MCQTestPage> {
  late Future<List<SubLevels>> _futureSubLevels;
  int currentQuestionIndex = 0;
  List<Questions>? questions;
  late List<int> selectedOptions;
  late String levelName;
  bool allQuestionsAnswered = false;
  bool isLastQuestion = false;
  int currentCombo = 0;
  int maxCombo = 0;
  bool isTestAnswered = false;

  @override
  void initState() {
    super.initState();
    _futureSubLevels = _fetchSubLevels();
    selectedOptions = List<int>.filled(5, -1);
  }

  Future<List<SubLevels>> _fetchSubLevels() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }
      String encodedLevelName = Uri.encodeComponent(levelName);
      final response = await http.get(
        Uri.parse(
            'http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/sublevels/$encodedLevelName'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) => SubLevels.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load guidebooks');
      }
    } catch (error) {
      print('Error fetching sublevels: $error');
      rethrow;
    }
  }

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void selectOption(int index) {
    setState(() {
      selectedOptions[currentQuestionIndex] = index;
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions!.length - 1) {
        currentQuestionIndex++;
      } else {
        submitAnswer();
      }
    });
  }

  void submitAnswer() {
    String selectedOption =
        questions![currentQuestionIndex].options[selectedOptions[currentQuestionIndex]];
    bool isCorrect = selectedOption == questions![currentQuestionIndex].correctOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect. Try again!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  currentCombo++;
                  maxCombo = max(maxCombo, currentCombo); // Update max combo if needed
                  nextQuestion();
                  if (currentQuestionIndex == questions!.length - 1) {
                    isLastQuestion = true;
                    allQuestionsAnswered = true;
                    isTestAnswered = true; // Set test as answered when last question is answered
                  }
                } else {
                  currentCombo = 0; // Reset combo if incorrect
                }
                print('Current Combo: $currentCombo');
                print('Max Combo: $maxCombo');
                if (isTestAnswered) {
                  print('MCQ Test Answered');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // Reset selected options
    selectedOptions[currentQuestionIndex] = -1;
  }


  Future<void> _showNextTestConfirmationDialog() {
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
                Navigator.pushNamed(context, '/audiovisual');
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


  void checkAndShowConfirmationDialog() {
  if (allQuestionsAnswered && isLastQuestion) {
      _showNextTestConfirmationDialog();
      allQuestionsAnswered = false; // Reset to false after showing the dialog
    }
}

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String lvlName = args?['levelName'] ?? '';
    levelName = lvlName;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.levelName} MCQ Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _futureSubLevels,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final subLevels = snapshot.data as List<SubLevels>;
                questions = subLevels[0].questions;
                return Column(
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
                      questions![currentQuestionIndex].question,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: questions![currentQuestionIndex].options.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              selectOption(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                                color: selectedOptions[currentQuestionIndex] == index
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              child: Text(
                                questions![currentQuestionIndex].options[index],
                                style: TextStyle(
                                  color: selectedOptions[currentQuestionIndex] == index
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedOptions[currentQuestionIndex] != -1) {
                          checkAndShowConfirmationDialog();
                          submitAnswer();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an option'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                );
              }
            }
            return Container(); // Placeholder widget
          },
        ),
      ),
    );
  }
}