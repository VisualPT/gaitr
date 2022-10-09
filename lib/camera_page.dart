import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'editor_page.dart';

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
  late String datetime;
  Timer? timer;

  @override
  void initState() {
    //TODO  "Requires full screen" to true in the Xcode Deployment Info.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    _initCameraServices();
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
    setState(() => _isRecording
        ? duration = Duration(milliseconds: duration.inMilliseconds + 1)
        : null);
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  _initCameraServices() async {
    final cameras = await availableCameras();

    _cameraController = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back),
        ResolutionPreset.high);
    await _cameraController.initialize();
    await _cameraController
        .lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    await _cameraController.prepareForVideoRecording();
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
            builder: (_) => EditorPage(file: File(file.path)));
        Navigator.push(context, route);
        resetTimer();
      });
    } else {
      await _cameraController.startVideoRecording().onError(
          //TODO Check if video is broken and reset the controller if so
          (error, stackTrace) => null);
      startTimer();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width / 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      formatter(duration),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: _isLoading
            ? Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Stack(
                alignment: Alignment.centerLeft,
                children: [
                  FractionallySizedBox(
                      widthFactor: 1, child: CameraPreview(_cameraController)),
                  GestureDetector(
                    onTap: () => _recordVideo(),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.circle,
                      color: _isRecording ? Colors.red : Colors.white,
                      size: 80,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(60).toString().padLeft(2, '0')[0]
      ].join(".");
}
