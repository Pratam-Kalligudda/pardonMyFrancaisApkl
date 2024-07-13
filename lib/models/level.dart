// models/level.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'guidebook_content.dart';

List<Levels> levelsFromJson(String str) => List<Levels>.from(json.decode(str).map((x) => Levels.fromJson(x)));

String levelsToJson(List<Levels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Levels with ChangeNotifier {
  final String levelName;
  final String subtitle;
  final List<GuidebookContent> guidebookContent;

  Levels({
    required this.levelName,
    required this.subtitle,
    required this.guidebookContent,
  });

  factory Levels.fromJson(Map<String, dynamic> json) => Levels(
        levelName: json["level_name"],
        subtitle: json["subtitle"],
        guidebookContent: List<GuidebookContent>.from(
            json["guidebook_content"].map((x) => GuidebookContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "subtitle": subtitle,
        "guidebook_content": List<dynamic>.from(guidebookContent.map((x) => x.toJson())),
      };
}
