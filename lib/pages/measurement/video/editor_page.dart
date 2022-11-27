import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gaitr/components/consent_dialog.dart';
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
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  void logGaitVelocityStats(VideoPlayerController controller) {
    final double milliseconds =
        controller.value.duration.inMilliseconds.toDouble();
    patientData.measurementDuration = milliseconds;
    patientData.velocity = (10 / (milliseconds / 1000)).toStringAsPrecision(2);
  }

  @override
  //TODO make TrimSlider change with button presses
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0x00000000),
        border: Border.all(color: const Color(0x00000000)),
        middle: AnimatedBuilder(
          animation: _editorController.video,
          builder: (_, __) {
            final duration =
                _editorController.video.value.duration.inMilliseconds;
            // final pos = _editorController.trimPosition * duration;
            final start = _editorController.minTrim * duration;
            final end = _editorController.maxTrim * duration;

            return Padding(
                padding: EdgeInsets.symmetric(horizontal: height / 4),
                child: OpacityTransition(
                  visible: true,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(formatter(Duration(milliseconds: start.toInt()))),
                    const SizedBox(width: 10),
                    Text(formatter(Duration(milliseconds: end.toInt()))),
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
                          const SizedBox(width: 20),
                          CupertinoButton(
                              padding: const EdgeInsets.only(
                                  top: 1, bottom: 1, right: 10, left: 10),
                              child: const Icon(CupertinoIcons.left_chevron),
                              color: const Color(0xFFEC7723),
                              onPressed: () {
                                _editorController.updateTrim(
                                    _editorController.minTrim - 0.1,
                                    _editorController.maxTrim);
                                setState(() {});
                              }),
                          const SizedBox(width: 10),
                          CupertinoButton(
                            padding: const EdgeInsets.only(
                                top: 1, bottom: 1, right: 10, left: 10),
                            child: const Icon(CupertinoIcons.right_chevron),
                            color: const Color(0xFFEC7723),
                            onPressed: () {
                              print(_editorController.minTrim);
                              setState(() {
                                _editorController.updateTrim(
                                    _editorController.minTrim + 0.1,
                                    _editorController.maxTrim);
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: height,
                            width: MediaQuery.of(context).size.width / 3,
                            child: TrimSlider(
                              controller: _editorController,
                            ),
                          ),
                          const SizedBox(width: 20),
                          CupertinoButton(
                              padding: const EdgeInsets.only(
                                  top: 1, bottom: 1, right: 10, left: 10),
                              child: const Icon(CupertinoIcons.left_chevron),
                              color: const Color(0xFFEC7723),
                              onPressed: () => _editorController.updateTrim(
                                  _editorController.minTrim,
                                  _editorController.maxTrim - 0.1)),
                          const SizedBox(width: 10),
                          CupertinoButton(
                            padding: const EdgeInsets.only(
                                top: 1, bottom: 1, right: 10, left: 10),
                            child: const Icon(CupertinoIcons.right_chevron),
                            color: const Color(0xFFEC7723),
                            onPressed: () => _editorController.updateTrim(
                                _editorController.minTrim,
                                _editorController.maxTrim + 0.1),
                          ),
                          const SizedBox(width: 20),
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
                                _editorController.endTrim -
                                    _editorController.startTrim;
                                _editorController.video.pause().then((_) {
                                  logGaitVelocityStats(_editorController.video);
                                  consentDialog(
                                      context,
                                      "Save Sample?",
                                      "Final time was ${formatter(_editorController.videoDuration)} seconds",
                                      "No",
                                      "Yes",
                                      () => Navigator.pop(context),
                                      () =>
                                          Navigator.pushNamed(context, '/pdf'));
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
        duration.inSeconds.remainder(99).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
      ].join(".");
}
