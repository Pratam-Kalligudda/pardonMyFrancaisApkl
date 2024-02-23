// models/level.dart

import 'dart:convert';

List<Levels> levelsFromJson(String str) => List<Levels>.from(json.decode(str).map((x) => Levels.fromJson(x)));

String levelsToJson(List<Levels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Levels {
    String levelName;
    List<GuidebookContent> guidebookContent;

    Levels({
        required this.levelName,
        required this.guidebookContent,
    });

    factory Levels.fromJson(Map<String, dynamic> json) => Levels(
        levelName: json["level_name"],
        guidebookContent: List<GuidebookContent>.from(json["guidebook_content"].map((x) => GuidebookContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "guidebook_content": List<dynamic>.from(guidebookContent.map((x) => x.toJson())),
    };
}

class GuidebookContent {
    String frenchWord;
    String frenchPronunciation;
    String englishTranslation;

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

