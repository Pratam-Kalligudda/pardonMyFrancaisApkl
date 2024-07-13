//pages/audio_visual_test_page.dart

import 'package:flutter/material.dart';
import 'package:french_app/pages/recording_page.dart';
import 'package:french_app/providers/guidebook_provider.dart';
import 'package:french_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioVisualTestPage extends StatefulWidget {
  final String lessonName;
  final String levelName;

  const AudioVisualTestPage({
    Key? key,
    required this.lessonName,
    required this.levelName,
  }) : super(key: key);

  @override
  State<AudioVisualTestPage> createState() => _AudioVisualTestPageState();
}

class _AudioVisualTestPageState extends State<AudioVisualTestPage> {
  late String levelName;
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  Future<void> _speakPhrase(String phrase) async {
    setState(() {
      isPlaying = true;
    });

    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(phrase);

    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String lvlName = args?['levelName'] ?? '';
    levelName = lvlName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.levelName} Pronunciation Test',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<LevelProvider>(
      builder: (context, levelProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 50.0),
            Text(
              'French Pronunciation Test',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50.0),
            _buildFrenchWordText(levelProvider),
            const SizedBox(height: 10.0),
            _buildEnglishTranslationText(levelProvider),
            const SizedBox(height: 5.0),
            _buildFrenchPronunciationText(levelProvider),
            const SizedBox(height: 80.0),
            Text(
              'Play Audio',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            IconButton(
              icon: Icon(isPlaying ? Icons.stop : Icons.volume_up),
              onPressed: () {
                if (!isPlaying) {
                  _speakPhrase(_getFrenchWord(levelProvider));
                } else {
                  flutterTts.stop();
                }
              },
            ),
            const SizedBox(height: 80.0),
            _buildInstructions(),
            const SizedBox(height: 30.0),
            _buildRecordButton(),
          ],
        );
      },
    );
  }

  Widget _buildFrenchWordText(LevelProvider levelProvider) {
    return Text(
      levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
          ? levelProvider.levels[0].guidebookContent[0].frenchWord
          : 'French Word',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEnglishTranslationText(LevelProvider levelProvider) {
    return Text(
      levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
          ? levelProvider.levels[0].guidebookContent[0].englishTranslation
          : 'English Translation',
      style: TextStyle(
        fontSize: 14.0,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFrenchPronunciationText(LevelProvider levelProvider) {
    return Text(
      levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
          ? levelProvider.levels[0].guidebookContent[0].frenchPronunciation
          : 'French Pronunciation',
      style: TextStyle(
        fontSize: 14.0,
        fontStyle: FontStyle.italic,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      textAlign: TextAlign.center,
    );
  }

  String _getFrenchWord(LevelProvider levelProvider) {
    return levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
        ? levelProvider.levels[0].guidebookContent[0].frenchWord
        : 'French Word';
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        'As a final part of completing the lesson we will check your pronunciation and tell you how accurate your pronunciation is',
        style: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRecordButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomButton(
        text: 'Record',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RecordingPage(),
            ),
          );
        },
        isLoading: false,
      ),
    );
  }
}
