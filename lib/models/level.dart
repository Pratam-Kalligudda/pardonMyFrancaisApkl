// models/level.dart

import 'dart:convert';

List<Levels> levelsFromJson(String str) => List<Levels>.from(json.decode(str).map((x) => Levels.fromJson(x)));

String levelsToJson(List<Levels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Levels {
    String levelName;
    String subtitle;
    List<GuidebookContent> guidebookContent;
    bool isMCQCompleted;
    bool isPronunciationTestCompleted;

    Levels({
        required this.levelName,
        required this.subtitle,
        required this.guidebookContent,
        this.isMCQCompleted = false,
        this.isPronunciationTestCompleted = false,
    });

    factory Levels.fromJson(Map<String, dynamic> json) => Levels(
        levelName: json["level_name"],
        subtitle: json["subtitle"],
        guidebookContent: List<GuidebookContent>.from(json["guidebook_content"].map((x) => GuidebookContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "subtitle" : subtitle,
        "guidebook_content": List<dynamic>.from(guidebookContent.map((x) => x.toJson())),
    };
}

class GuidebookContent {
    String frenchWord;
    String frenchPronunciation;
    String englishTranslation;
    bool isPronunciationTestCompleted;
    bool isMCQTestCompleted;

    GuidebookContent({
        required this.frenchWord,
        required this.frenchPronunciation,
        required this.englishTranslation,
        this.isPronunciationTestCompleted = false,
        this.isMCQTestCompleted = false,
    });

    factory GuidebookContent.fromJson(Map<String, dynamic> json) => GuidebookContent(
        frenchWord: json["french_word"],
        frenchPronunciation: json["french_pronunciation"],
        englishTranslation: json["english_translation"],
        isMCQTestCompleted: json["is_mcq_test_completed"] ?? false,
        isPronunciationTestCompleted: json["is_pronunciation_test_completed"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "french_word": frenchWord,
        "french_pronunciation": frenchPronunciation,
        "english_translation": englishTranslation,
        "is_mcq_test_completed": isMCQTestCompleted,
        "is_pronunciation_test_completed": isPronunciationTestCompleted,
    };
}

