// pages/mcq_test_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:french_app/models/questions.dart';
import 'package:french_app/models/sublevel.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:french_app/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  String apiUrl = dotenv.env['MY_API_URL']!;
  late Future<List<SubLevels>> _futureSubLevels;
  int currentQuestionIndex = 0;
  List<Questions>? questions;
  List<int> selectedOptions = [];
  late String levelName;
  double score = 0;
  bool allCorrect = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    levelName = widget.levelName;
    _futureSubLevels = _fetchSubLevels();
  }

  Future<List<SubLevels>> _fetchSubLevels() async {
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }
      String encodedLevelName = Uri.encodeComponent(levelName);
      final response = await http.get(
        Uri.parse('$apiUrl/sublevels/$encodedLevelName'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) => SubLevels.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sublevels');
      }
    } catch (error) {
      errorMessage = error.toString();
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
      }
    });
  }

  void submitAnswer() {
    String selectedOption = questions![currentQuestionIndex]
        .options[selectedOptions[currentQuestionIndex]];
    bool isCorrect =
        selectedOption == questions![currentQuestionIndex].correctOption;

    if (!isCorrect) {
      allCorrect = false;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isCorrect ? 'Correct!' : 'Incorrect!',
            style: TextStyle(
              fontSize: 24,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          content: !isCorrect
              ? Text(
                  'The correct answer is: ${questions![currentQuestionIndex].correctOption}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  score += 100 / questions!.length;
                }
                if (currentQuestionIndex == questions!.length - 1) {
                  checkAndShowConfirmationDialog();
                } else {
                  nextQuestion();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String extractLevelNumber(String levelString) {
    final RegExp regex = RegExp(r'\d+');
    final match = regex.firstMatch(levelString);
    return match != null ? match.group(0) ?? '' : '';
  }

  Future<void> sendScoreToServer() async {
    final jwtToken = await _getJwtToken();
    if (jwtToken == null) {
      throw Exception('JWT token not found');
    }

    String extractedLevel = extractLevelNumber(levelName);
    int currentLevel = int.parse(extractedLevel);
    final requestData = {
      "current_level": currentLevel,
      "level_scores": {
        "$currentLevel": score,
      },
      "allQuestionsRight": allCorrect,
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/updateUserProgress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userProgress', response.body);

        Provider.of<ProgressProvider>(context, listen: false).loadUserProgress();
      }
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    }
  }

  void checkAndShowConfirmationDialog() {
    if (selectedOptions.every((element) => element != -1)) {
      if (allCorrect) {
        allCorrect = true;
      }
      sendScoreToServer();
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/audiovisual');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          levelName,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<SubLevels>>(
          future: _futureSubLevels,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final subLevels = snapshot.data!;
              questions = subLevels[0].questions;
              if (selectedOptions.isEmpty) {
                selectedOptions = List<int>.filled(questions!.length, -1);
              }
              return buildMCQTestView(context);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildMCQTestView(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Multiple Choice Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Select the correct option for the question from the given options',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          Text(
            questions![currentQuestionIndex].question,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
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
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.surface
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                   child: Text(
                      questions![currentQuestionIndex].options[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedOptions[currentQuestionIndex] == index
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onSurface
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: currentQuestionIndex == questions!.length - 1 ? 'Submit' : 'Next',
            onPressed: () {
              if (selectedOptions[currentQuestionIndex] == -1) {
                showStyledSnackBar(context, 'Please select an option before proceeding');
              } else {
                submitAnswer();
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
