// models/level.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'guidebook_content.dart';

/// Parses JSON strings into Levels objects and vice versa.
List<Levels> levelsFromJson(String str) => List<Levels>.from(json.decode(str).map((x) => Levels.fromJson(x)));

/// Converts a list of Levels objects into a JSON string.
String levelsToJson(List<Levels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Represents a learning level with its details and content.
class Levels with ChangeNotifier {
  final String levelName;
  final String subtitle;
  final List<GuidebookContent> guidebookContent;

  Levels({
    required this.levelName,
    required this.subtitle,
    required this.guidebookContent,
  });

  /// Converts a JSON map into a Levels object.
  factory Levels.fromJson(Map<String, dynamic> json) => Levels(
        levelName: json["level_name"],
        subtitle: json["subtitle"],
        guidebookContent: List<GuidebookContent>.from(
            json["guidebook_content"].map((x) => GuidebookContent.fromJson(x))),
      );

  /// Converts a Levels object into a JSON map.
  Map<String, dynamic> toJson() => {
        "level_name": levelName,
        "subtitle": subtitle,
        "guidebook_content": List<dynamic>.from(guidebookContent.map((x) => x.toJson())),
      };
}
