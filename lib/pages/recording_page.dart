import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

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

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

      _controller = CameraController(
        frontCamera,
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
        await extractAudioAndSend(video.path);
      } catch (e) {
        print('Error stopping video recording: $e');
      }
    }
  }

  Future<void> extractAudioAndSend(String videoPath) async {
    final flutterFFmpeg = FlutterFFmpeg();
    final outputAudioPath = videoPath.replaceAll('.mp4', '.mp3');
    final arguments = ['-i', videoPath, '-vn', '-acodec', 'copy', outputAudioPath];

    try {
      await flutterFFmpeg.executeWithArguments(arguments);
    } catch (e) {
      print('Error extracting audio: $e');
      return;
    }

    final audioFile = File(outputAudioPath);

    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://ec2-18-208-214-241.compute-1.amazonaws.com:8080/api/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', outputAudioPath));

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() async {
          _accuracyScore = double.parse(await response.stream.bytesToString());
          _accuracyDisplayed = true;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pronunciation Accuracy'),
            content: Text('Your pronunciation accuracy score is: $_accuracyScore%'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _accuracyDisplayed = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to get accuracy score. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending audio to server: $e');
    }
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
                      if (!_isRecording && !_accuracyDisplayed)
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
                            Navigator.pop(context);
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
