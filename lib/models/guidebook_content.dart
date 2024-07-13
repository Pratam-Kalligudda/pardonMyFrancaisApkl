// models/guidebook_content.dart

class GuidebookContent {
  final String frenchWord;
  final String frenchPronunciation;
  final String englishTranslation;

  GuidebookContent({
    required this.frenchWord,
    required this.frenchPronunciation,
    required this.englishTranslation,
  });

  factory GuidebookContent.fromJson(Map<String, dynamic> json) => GuidebookContent(
        frenchWord: json["french_word"],
        frenchPronunciation: json["french_pronunciation"],
        englishTranslation: json["english_translation"],
      );

  Map<String, dynamic> toJson() => {
        "french_word": frenchWord,
        "french_pronunciation": frenchPronunciation,
        "english_translation": englishTranslation,
      };
}
