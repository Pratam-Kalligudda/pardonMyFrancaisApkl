import 'package:flutter/material.dart';
import 'package:french_app/pages/recording_page.dart'; // To use Future.delayed for simulating network request

class AudioVisualTestPage extends StatelessWidget {
  const AudioVisualTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Test'),
      ),
      body: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.0),
                Text(
                  'Pronunciation Test',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.0),
                Text(
                  'French Word',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Translation',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Meaning',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Pronunciation',
                  style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
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
          const Positioned(
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