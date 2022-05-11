import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'video_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  Duration duration = const Duration(seconds: 0);
  late double finaltime;
  Timer? timer;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      timer =
          Timer.periodic(const Duration(milliseconds: 1), (_) => increment());
    });
  }

  void increment() {
    const add = 1;
    setState(() {
      if (_isRecording) {
        final milliseconds = duration.inMilliseconds + add;
        duration = Duration(milliseconds: milliseconds);
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(back, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
        finaltime = duration.inMilliseconds / 1000;
        final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => VideoPage(filePath: file.path, duration: finaltime),
        );
        Navigator.push(context, route);
        resetTimer();
      });
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      startTimer();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(child: CameraPreview(_cameraController)),
            const Positioned.fill(
              right: 260,
              child: VerticalDivider(
                width: 10,
                thickness: 3,
                indent: 10,
                endIndent: 120,
                color: Colors.green,
              ),
            ),
            const Positioned.fill(
              left: 260,
              child: VerticalDivider(
                width: 10,
                thickness: 3,
                indent: 10,
                endIndent: 120,
                color: Colors.red,
              ),
            ),
            const Positioned(
                child: Text(
                  '-------10ft-------',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                    decoration: TextDecoration.none,
                  ), //Gets rid of yellow lines
                ),
                bottom: 160),
            const Positioned.fill(
              top: 260,
              child: Divider(
                height: 10,
                thickness: 3,
                indent: 60,
                endIndent: 60,
                color: Colors.orange,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Text(
                'Duration: ${(duration.inMilliseconds / 1000).round()} sec',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 30,
                    decoration: TextDecoration.none), //Gets rid of yellow lines
              ),
            ),
          ],
        ),
      );
    }
  }
}
