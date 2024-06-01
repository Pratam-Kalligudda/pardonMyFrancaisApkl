import 'package:flutter/material.dart';

class AudioVideoPage extends StatelessWidget {
  const AudioVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording'),
      ),
      body: Stack(
        children: [
          Center(
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
              ],
            ),
          ),
          Positioned(
            bottom: 100.0, // Adjust the top distance as needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Please click the button below to start recording:',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Positioned(
            bottom: 40.0, // Adjust the bottom distance as needed
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add your record button functionality here
                },
                child: Text('Record'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
