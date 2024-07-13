// models/sublevel.dart

import 'dart:convert';
import 'questions.dart'; 

List<SubLevels> subLevelsFromJson(String str) =>
    List<SubLevels>.from(json.decode(str).map((x) => SubLevels.fromJson(x)));

String subLevelsToJson(List<SubLevels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubLevels {
  final String levelName;
  final List<Questions> questions;

  SubLevels({
    required this.levelName,
    required this.questions,
  });

  factory SubLevels.fromJson(Map<String, dynamic> json) {
    return SubLevels(
      levelName: json["level_name"],
      questions: List<Questions>.from(json["questions"].map((x) => Questions.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
