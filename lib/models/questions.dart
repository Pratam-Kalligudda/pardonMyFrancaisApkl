// models/questions.dart

/// Represents a quiz question with options and correct answer.
class Questions {
  final String question;
  final List<String> options;
  final String correctOption;

  Questions({
    required this.question,
    required this.options,
    required this.correctOption,
  });

  /// Converts a JSON map into a Questions object.
  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      question: json["question"],
      options: List<String>.from(json["options"].map((x) => x)),
      correctOption: json["correct_option"],
    );
  }

  /// Converts a Questions object into a JSON map.
  Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "correct_option": correctOption,
      };
}
