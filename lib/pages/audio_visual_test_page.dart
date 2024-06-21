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

  Future<void> _speakPhrase(String phrase) async {
    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(phrase);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String lvlName = args?['levelName'] ?? '';
    levelName = lvlName;

    final levelProvider = Provider.of<LevelProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.levelName} Pronunciation Test',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              Text(
                'French Pronunciation Test',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 50.0),

              _buildFrenchWordText(levelProvider),
              const SizedBox(height: 10.0),
              _buildEnglishTranslationText(levelProvider),
              const SizedBox(height: 5.0),
              _buildFrenchPronunciationText(levelProvider),
              const SizedBox(height: 80.0),

              Text('Play Audio', style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.secondary)),
              const SizedBox(height: 10.0),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () {
                  _speakPhrase(_getFrenchPronunciation(levelProvider));
                },
              ),
              const SizedBox(height: 80.0),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'As a final part of completing the lesson we will check your pronunciation and tell you how accurate your pronunciation is',
                  style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Please click the button below to start recording',
                style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 30.0),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  text: 'Record',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecordingPage()),
                    );
                  }, isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrenchWordText(LevelProvider levelProvider) {
    return Text(
      levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
          ? levelProvider.levels[0].guidebookContent[0].frenchWord
          : 'French Word',
      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground,),
    );
  }

  Widget _buildEnglishTranslationText(LevelProvider levelProvider) {
    return Text(
      levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
          ? levelProvider.levels[0].guidebookContent[0].englishTranslation
          : 'English Translation',
      style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onBackground,),
    );
  }

  Widget _buildFrenchPronunciationText(LevelProvider levelProvider) {
    return Text(
      levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
          ? levelProvider.levels[0].guidebookContent[0].frenchPronunciation
          : 'French Pronunciation',
      style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.onBackground,),
    );
  }

  String _getFrenchPronunciation(LevelProvider levelProvider) {
    return levelProvider.levels.isNotEmpty && levelProvider.levels[0].guidebookContent.isNotEmpty
        ? levelProvider.levels[0].guidebookContent[0].frenchPronunciation
        : 'French Pronunciation';
  }
}
