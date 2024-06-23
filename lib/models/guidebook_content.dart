// models/guidebook_content.dart

/// Represents content for a guidebook entry in multiple languages.
class GuidebookContent {
  final String frenchWord;
  final String frenchPronunciation;
  final String englishTranslation;

  GuidebookContent({
    required this.frenchWord,
    required this.frenchPronunciation,
    required this.englishTranslation,
  });

  /// Converts a JSON map into a GuidebookContent object.
  factory GuidebookContent.fromJson(Map<String, dynamic> json) => GuidebookContent(
        frenchWord: json["french_word"],
        frenchPronunciation: json["french_pronunciation"],
        englishTranslation: json["english_translation"],
      );

  /// Converts a GuidebookContent object into a JSON map.
  Map<String, dynamic> toJson() => {
        "french_word": frenchWord,
        "french_pronunciation": frenchPronunciation,
        "english_translation": englishTranslation,
      };
}
