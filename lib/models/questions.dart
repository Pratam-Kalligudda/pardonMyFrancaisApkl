// models/questions.dart

class Questions {
  final String question;
  final List<String> options;
  final String correctOption;

  Questions({
    required this.question,
    required this.options,
    required this.correctOption,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      question: json["question"],
      options: List<String>.from(json["options"].map((x) => x)),
      correctOption: json["correct_option"],
    );
  }

  Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "correct_option": correctOption,
      };
}