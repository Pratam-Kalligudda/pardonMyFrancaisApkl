// providers/guidebook_provider.dart

import 'package:flutter/material.dart';
import 'package:french_app/models/level.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GuidebookProvider with ChangeNotifier {
  List<Levels> _guidebooks = [];
  final String levelName;

  GuidebookProvider(this.levelName);

  List<Levels> get guidebooks => _guidebooks;
   Future<String?> _getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchGuidebooks() async {
    
    try {
      final jwtToken = await _getJwtToken();
      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }
      final response = await http.get(
        Uri.parse(
            'http://ec2-44-211-62-237.compute-1.amazonaws.com/api/guidebook/$levelName'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        _guidebooks =
            jsonResponse.map((json) => Levels.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load guidebooks');
      }
    } catch (error) {
      throw error;
    }
  }
}
