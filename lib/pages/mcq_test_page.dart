import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:french_app/models/sublevel.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/providers/user_provider.dart';
import 'package:french_app/widgets/custom_button.dart';
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
  late Future<List<SubLevels>> _futureSubLevels;
  int currentQuestionIndex = 0;
  List<Questions>? questions;
  List<int> selectedOptions = [];
  late String levelName;
  // bool allQuestionsAnswered = false;
  // bool isLastQuestion = false;
  // bool isMcqTestAnswered = false;
  // int correctAnswers = 0;
  double score = 0;
  bool allCorrect = true;

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
        Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/sublevels/$encodedLevelName'),
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
      // print('Error fetching sublevels: $error');
      rethrow;
    }
  }

  Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void selectOption(int index) {
    setState(() {
      // print('Select option called: $index');
      selectedOptions[currentQuestionIndex] = index;
      // print(selectedOptions);
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions!.length - 1) {
        currentQuestionIndex++;
        // print("Next question index: $currentQuestionIndex");
      } else {
        // isLastQuestion = true;
        // print("Last question reached. Test completed.");
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

    // print("Selected option: $selectedOption");
    // print("Is correct: $isCorrect");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correct!' : 'Incorrect!',
          style: TextStyle(
            fontSize: 24,
            color: isCorrect ? Colors.green : Colors.red
            ),
          ),
          content: !isCorrect
              ? Text('The correct answer is: ${questions![currentQuestionIndex].correctOption}',
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
                  // correctAnswers++;
                  score += 100 / questions!.length;
                }
                // print('Correct Answers: $correctAnswers');
                // print('Score: $score');
                // print(isLastQuestion);
                if (currentQuestionIndex == questions!.length - 1) {
                  // print(isLastQuestion);
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
        Uri.parse('http://ec2-52-91-198-166.compute-1.amazonaws.com:8080/api/updateUserProgress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(requestData),
      );
      // print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // print('Score successfully sent to server');
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userProgress', response.body);

      } else {
        // print('Failed to send score to server: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error sending score to server: $error');
    }
  }

  void _submitTest(String levelName, double score) {
    Provider.of<UserProvider>(context, listen: false).updateLevelScore(levelName, score);
  }

  void checkAndShowConfirmationDialog() {
    if (selectedOptions.every((element) => element != -1)) {
      // allQuestionsAnswered = true;
      if (allCorrect) {
        allCorrect = true;
        // print('All questions were answered correctly.');
      } else {
        // print('Not all questions were answered correctly.');
      }
      // print(score);
      sendScoreToServer();
      _submitTest(levelName, score);
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/audiovisual');
      });
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
        title: Text(levelName,
         style: const TextStyle(
            fontSize: 20,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                // print('Questions length: ${questions?.length}');
                if (selectedOptions.isEmpty) {
                  selectedOptions = List<int>.filled(questions!.length, -1);
                }
                // print(selectedOptions);
                return buildMCQTestView(context);
              }
            }
            return const Center(child: CircularProgressIndicator());
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
                fontSize: 26,
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
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          Text(
            questions![currentQuestionIndex].question,
            style: TextStyle(
              fontSize: 20,
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
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text(
                      questions![currentQuestionIndex].options[index],
                      style: TextStyle(
                        color: selectedOptions[currentQuestionIndex] == index
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Submit Answer',
            onPressed: () {
              if (selectedOptions[currentQuestionIndex] != -1) {
                submitAnswer();
              }
            }, isLoading: false,
          ),
        ],
      ),
    );
  }
}
