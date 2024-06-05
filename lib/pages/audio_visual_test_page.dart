import 'package:flutter/material.dart';
import 'package:french_app/pages/recording_page.dart';
import 'package:french_app/providers/guidebook_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioVisualTestPage extends StatefulWidget {
  AudioVisualTestPage({Key? key}) : super(key: key);

  @override
  State<AudioVisualTestPage> createState() => _AudioVisualTestPageState();
}

class _AudioVisualTestPageState extends State<AudioVisualTestPage> {
  bool testAnswered = false;

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speakPhrase(String phrase) async {
  await flutterTts.setLanguage('fr-FR'); // Set language to French
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.5); // Set pitch (1.0 is default)
  await flutterTts.speak(phrase);
}

  @override
  Widget build(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);

    if (testAnswered) {
      print('The audio visual test was answered.'); // Print in the console that the test was answered
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Test'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.0),
                Text(
                  'French Pronunciation Test',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.0),
                // Display fetched data from the backend
                if (levelProvider.levels.isNotEmpty)
                  Text(
                    levelProvider.levels[0].guidebookContent.isNotEmpty
                        ? levelProvider.levels[0].guidebookContent[0].frenchWord
                        : 'French Word',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  )
                else
                  Text('French Word'),
                SizedBox(height: 10.0),
                if (levelProvider.levels.isNotEmpty)
                  Text(
                    levelProvider.levels[0].guidebookContent.isNotEmpty
                        ? levelProvider.levels[0].guidebookContent[0].englishTranslation
                        : 'English Translation',
                    style: TextStyle(fontSize: 18.0),
                  )
                else
                  Text('English Translation'),
                SizedBox(height: 5.0),
                if (levelProvider.levels.isNotEmpty)
                  Text(
                    levelProvider.levels[0].guidebookContent.isNotEmpty
                        ? levelProvider.levels[0].guidebookContent[0].frenchPronunciation
                        : 'French Pronunciation',
                    style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                  )
                else
                  Text('French Pronunciation'),
                SizedBox(height: 100.0),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () {
                    _speakPhrase(levelProvider.levels.isNotEmpty
                        ? levelProvider.levels[0].guidebookContent.isNotEmpty
                            ? levelProvider.levels[0].guidebookContent[0].frenchPronunciation
                            : 'French Pronunciation'
                        : 'French Pronunciation');
                  },
                ),
                SizedBox(height: 100.0),
                Center(
                  child: Text(
                    'As a final part of completing the lesson we will check your pronunciation and tell you how accurate your pronunciation is',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 160.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Please click the button below to start recording',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Positioned(
            bottom: 100.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecordingPage()),
                  );
                  testAnswered = true;
                  // Print to console that the test was answered
                  print('Test was answered: $testAnswered');
                },
                child: const Text('Record'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
