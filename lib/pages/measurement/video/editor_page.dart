import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_editor/video_editor.dart';
import 'package:helpers/helpers.dart' show OpacityTransition;
import 'package:gaitr/models/patient_data.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final double height = 60;
  late VideoEditorController _editorController;
  //late VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _editorController = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 60))
      ..initialize().then((_) => setState(() {}));
    //_controller.video.setLooping(true);
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  void logGaitVelocityStats(VideoPlayerController controller) {
    final double seconds = controller.value.duration.inMilliseconds / 1000;
    patientData.measurementDuration = seconds;
    patientData.velocity = (10 / seconds).toStringAsPrecision(2);
  }

  @override
  //TODO show the total measurement time at all times
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0x00000000),
        border: Border.all(color: const Color(0x00000000)),
        middle: AnimatedBuilder(
          animation: _editorController.video,
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
      child: _editorController.initialized
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
                          if (_editorController.isPlaying) {
                            _editorController.video.pause();
                          } else {
                            _editorController.video.play();
                          }
                        },
                        child: VideoPlayer(_editorController.video),
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
                              // height: ,
                              controller: _editorController,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CupertinoButton(
                              padding: const EdgeInsets.only(
                                  top: 1, bottom: 1, right: 20, left: 20),
                              color: CupertinoColors.link,
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
                                _editorController.video.pause().then((_) {
                                  logGaitVelocityStats(_editorController.video);
                                  Navigator.pushNamed(context, '/confirm');
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _editorController.video,
                  builder: (_, __) => OpacityTransition(
                    visible: !_editorController.isPlaying,
                    child: GestureDetector(
                      onTap: _editorController.video.play,
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.play_arrow,
                            color: CupertinoColors.black),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CupertinoActivityIndicator()),
    );
  }

  String formatter(Duration duration) => [
        duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");
}
