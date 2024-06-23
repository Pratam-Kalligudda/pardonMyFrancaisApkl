// models/sublevel.dart

import 'dart:convert';
import 'questions.dart'; 

/// Parses JSON strings into SubLevels objects and vice versa.
List<SubLevels> subLevelsFromJson(String str) =>
    List<SubLevels>.from(json.decode(str).map((x) => SubLevels.fromJson(x)));

/// Converts a list of SubLevels objects into a JSON string.
String subLevelsToJson(List<SubLevels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Represents a sub-level with its name and associated quiz questions.
class SubLevels {
  final String levelName;
  final List<Questions> questions;

  SubLevels({
    required this.levelName,
    required this.questions,
  });

  /// Converts a JSON map into a SubLevels object.
  factory SubLevels.fromJson(Map<String, dynamic> json) {
    return SubLevels(
      levelName: json["level_name"],
      questions: List<Questions>.from(json["questions"].map((x) => Questions.fromJson(x))),
    );
  }

  /// Converts a SubLevels object into a JSON map.
  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
