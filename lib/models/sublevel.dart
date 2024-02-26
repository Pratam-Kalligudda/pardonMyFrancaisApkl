// levels/sublevel.dart

import 'dart:convert';

List<SubLevels> subLevelsFromJson(String str) =>
    List<SubLevels>.from(json.decode(str).map((x) => SubLevels.fromJson(x)));

String subLevelsToJson(List<SubLevels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubLevels {
  String levelName;
  List<Questions> questions;

  SubLevels({
    required this.levelName,
    required this.questions,
  });

  factory SubLevels.fromJson(Map<String, dynamic> json) => SubLevels(
        levelName: json["level_name"],
        questions: List<Questions>.from(
            json["questions"].map((x) => Questions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Questions {
  String question;
  List<String> options;
  String correctOption;

  Questions({
    required this.question,
    required this.options,
    required this.correctOption,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        question: json["question"],
        options: List<String>.from(json["options"].map((x) => x)),
        correctOption: json["correct_option"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "correct_option": correctOption,
      };
}
