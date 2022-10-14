import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaiter/analysis_page.dart';
import 'package:video_player/video_player.dart';
import 'package:video_editor/video_editor.dart';
import 'package:helpers/helpers.dart' show OpacityTransition;

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final double height = 60;
  late VideoEditorController _editorController;
  late VideoPlayerController _playerController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _editorController = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 60))
      ..initialize().then((_) => setState(() {}));
    _playerController = _editorController.video;
    _playerController.play();
    //_controller.video.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedBuilder(
          animation: _playerController,
          builder: (_, __) {
            final duration = _editorController.video.value.duration.inSeconds;
            // final pos = _editorController.trimPosition * duration;
            final start = _editorController.minTrim * duration;
            final end = _editorController.maxTrim * duration;

            return Padding(
                padding: EdgeInsets.symmetric(horizontal: height / 4),
                child: OpacityTransition(
                  visible: _editorController.isTrimming,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(formatter(Duration(seconds: start.toInt()))),
                    const SizedBox(width: 10),
                    Text(formatter(Duration(seconds: end.toInt()))),
                  ]),
                ));
          },
        ),
      ),
      body: _editorController.initialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: GestureDetector(
                        onTap: () {
                          if (_playerController.value.isPlaying) {
                            _editorController.video.pause();
                          } else {
                            _editorController.video.play();
                          }
                        },
                        child: VideoPlayer(_playerController),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Row(
                        children: [
                          SizedBox(
                            height: height,
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: TrimSlider(
                              controller: _editorController,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              child: SizedBox(
                                  height: height,
                                  width: MediaQuery.of(context).size.width / 10,
                                  child: const Center(
                                    child: Text(
                                      "Analyze",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )),
                              onPressed: () {
                                final route = MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => const AnalysisPage());
                                Navigator.push(context, route);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _playerController,
                  builder: (_, __) => OpacityTransition(
                    visible: !_editorController.isPlaying,
                    child: GestureDetector(
                      onTap: _editorController.video.play,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.play_arrow, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  String formatter(Duration duration) => [
        duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");
}
