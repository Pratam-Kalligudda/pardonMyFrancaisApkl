// To parse this JSON data, do
//
//     final subLevels = subLevelsFromJson(jsonString);

import 'dart:convert';

List<SubLevels> subLevelsFromJson(String str) => List<SubLevels>.from(json.decode(str).map((x) => SubLevels.fromJson(x)));

String subLevelsToJson(List<SubLevels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubLevels {
    Id id;
    String levelName;
    List<Sublevel> sublevels;

    SubLevels({
        required this.id,
        required this.levelName,
        required this.sublevels,
    });

    factory SubLevels.fromJson(Map<String, dynamic> json) => SubLevels(
        id: Id.fromJson(json["_id"]),
        levelName: json["level_name"],
        sublevels: List<Sublevel>.from(json["sublevels"].map((x) => Sublevel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "level_name": levelName,
        "sublevels": List<dynamic>.from(sublevels.map((x) => x.toJson())),
    };
}

class Id {
    String oid;

    Id({
        required this.oid,
    });

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
    };
}

class Sublevel {
    String question;
    List<String> options;
    String correctOption;

    Sublevel({
        required this.question,
        required this.options,
        required this.correctOption,
    });

    factory Sublevel.fromJson(Map<String, dynamic> json) => Sublevel(
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
