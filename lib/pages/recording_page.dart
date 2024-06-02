import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async'; // To use Future.delayed for simulating network request


class RecordingPage extends StatefulWidget {
  const RecordingPage({Key? key}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  bool _accuracyDisplayed = false;
  double? _accuracyScore;

  void resetAccuracyDisplayed() {
  setState(() {
    _accuracyDisplayed = false;
  });
}

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> startRecording() async {
    if (_controller.value.isInitialized && !_isRecording) {
      try {
        await _controller.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        print('Error starting video recording: $e');
      }
    }
  }

  Future<void> stopRecording() async {
    if (_controller.value.isInitialized && _isRecording) {
      try {
        final video = await _controller.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
        print('Video recorded to: ${video.path}');
        await simulateNetworkRequest();
      } catch (e) {
        print('Error stopping video recording: $e');
      }
    }
  }

  Future<void> simulateNetworkRequest() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate a fake pronunciation accuracy score
    final fakeScore = (70 + (30 * (1 - 0.7 * 0.7))).roundToDouble();
    setState(() {
      _accuracyScore = fakeScore;
    });

    // Show the result in a dialog or any preferred UI element
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pronunciation Accuracy'),
        content: Text('Your pronunciation accuracy score is: $_accuracyScore%'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetAccuracyDisplayed();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox.expand(
                  child: CameraPreview(_controller),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isRecording  && !_accuracyDisplayed)
                        IconButton(
                          icon: const Icon(Icons.fiber_manual_record),
                          iconSize: 70,
                          color: Colors.red,
                          onPressed: startRecording,
                        ),
                      if (_isRecording)
                        IconButton(
                          icon: const Icon(Icons.stop),
                          iconSize: 70,
                          color: Colors.red,
                          onPressed: stopRecording,
                        ),
                      if (_isRecording || (!_isRecording && !_controller.value.isRecordingVideo))
                        IconButton(
                              icon: const Icon(Icons.cancel),
                              iconSize: 70,
                              color: Colors.grey,
                              onPressed: () {
                                _controller.stopVideoRecording();
                                setState(() {
                                  _isRecording = false;
                                });
                                Navigator.pop(context); // Go back to previous page
                              },
                            ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}