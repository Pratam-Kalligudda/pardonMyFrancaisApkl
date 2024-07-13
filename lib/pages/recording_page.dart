//page/recording_page.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  String apiUrl = dotenv.env['MY_API_URL']!;
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
      return;
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
        return;
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
        await extractAudioAndSend(video.path);
      } catch (e) {
        return;
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
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', outputAudioPath));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final accuracyScore = double.tryParse(responseBody);

        if (accuracyScore!= null) {
          setState(() {
            _accuracyScore = accuracyScore;
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
        }
      } else {
      }
    } catch (e) {
      return;
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
