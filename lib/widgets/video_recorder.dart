// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// class VideoRecorderPage extends StatefulWidget {
//   @override
//   _VideoRecorderPageState createState() => _VideoRecorderPageState();
// }

// class _VideoRecorderPageState extends State<VideoRecorderPage> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   bool _isRecording = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   Future<void> initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final camera = cameras.first;

//       _controller = CameraController(
//         camera,
//         ResolutionPreset.medium,
//       );

//       _initializeControllerFuture = _controller.initialize();
//       await _initializeControllerFuture;

//       if (mounted) {
//         startRecording();
//       }
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }

//   Future<void> startRecording() async {
//     if (_controller.value.isInitialized && !_isRecording) {
//       try {
//         await _controller.startVideoRecording();
//         setState(() {
//           _isRecording = true;
//         });
//       } catch (e) {
//         print('Error starting video recording: $e');
//       }
//     }
//   }

//   Future<void> stopRecording() async {
//     if (_controller.value.isInitialized && _isRecording) {
//       try {
//         final video = await _controller.stopVideoRecording();
//         setState(() {
//           _isRecording = false;
//         });
//         print('Video recorded to: ${video.path}');
//       } catch (e) {
//         print('Error stopping video recording: $e');
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recording in Progress'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.stop),
//             onPressed: _isRecording ? stopRecording : null,
//           ),
//         ],
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Center(
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: CameraPreview(_controller),
//               ),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
