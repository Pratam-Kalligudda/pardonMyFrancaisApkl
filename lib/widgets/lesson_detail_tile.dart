// widgets/lesson_detail_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class LessonDetailTile extends StatefulWidget {
  final String phrase;
  final String pronunciation;
  final String translation;
  final bool mcqCompleted;
  final bool pronunciationCompleted;

  const LessonDetailTile({
    Key? key,
    required this.phrase,
    required this.pronunciation,
    required this.translation,
    this.mcqCompleted = false,
    this.pronunciationCompleted = false,
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
      print('Error playing audio: $err');
    });
  }

  Future<void> _fetchAndPlayPronunciation() async {
    // print("object");
    // try {
    //   // Fetch the pronunciation audio
    //   final response = await http.get(
    //     Uri.parse(
    //         'http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/audio/$phrase'),
    //   );
    //   if (response.statusCode == 200) {
    //     // Play the audio
    //     Uint8List audio = response.bodyBytes;
    //     AudioPlayer audioPlayer = AudioPlayer();
    //     await audioPlayer.play(BytesSource(audio));
    //   } else {
    //     throw Exception('Failed to load pronunciation audio');
    //   }
    // } catch (e) {
    //   print('Error playing audio: $e');
    // }
    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setVolume(1.0);
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setPitch(1.0);
        await flutterTts.awaitSpeakCompletion(true);
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
              _buildText(widget.phrase, FontWeight.bold, 20, context),
              const SizedBox(height: 8),
              _buildText('Pronunciation: ${widget.pronunciation}', FontWeight.normal, 16,
                  context),
              const SizedBox(height: 4),
              _buildText(
                  'Translation: ${widget.translation}', FontWeight.normal, 16, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(
  String text,
  FontWeight fontWeight,
  double fontSize,
  BuildContext context,
) {
  return Row(
    children: [
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      // if (text.contains('Pronunciation:')) // Add pronunciation icon
      //   Icon(
      //     Icons.volume_up,
      //     color: widget.pronunciationCompleted
      //         ? Theme.of(context).colorScheme.primary
      //         : Theme.of(context).disabledColor,
      //   ),
      // if (text.contains('Translation:')) // Add MCQ icon
      //   Icon(
      //     Icons.quiz,
      //     color: widget.mcqCompleted
      //         ? Theme.of(context).colorScheme.primary
      //         : Theme.of(context).disabledColor,
      //   ),
    ],
  );
}

}
