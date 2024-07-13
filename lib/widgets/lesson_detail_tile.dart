// widgets/lesson_detail_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LessonDetailTile extends StatefulWidget {
  final String phrase;
  final String pronunciation;
  final String translation;

  const LessonDetailTile({
    Key? key,
    required this.phrase,
    required this.pronunciation,
    required this.translation,
  }) : super(key: key);

  @override
  State<LessonDetailTile> createState() => _LessonDetailTileState();
}

class _LessonDetailTileState extends State<LessonDetailTile> {
  late FlutterTts flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((err) {
      setState(() {
        isPlaying = false;
      });
    });

    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _fetchAndPlayPronunciation() async {
    await flutterTts.speak(widget.phrase);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _fetchAndPlayPronunciation(),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(widget.phrase, FontWeight.bold, 16, context),
              const SizedBox(height: 8),
              _buildText('Pronunciation: ${widget.pronunciation}', FontWeight.normal, 14, context),
              const SizedBox(height: 4),
              _buildText('Translation: ${widget.translation}', FontWeight.normal, 14, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text, FontWeight fontWeight, double fontSize, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}