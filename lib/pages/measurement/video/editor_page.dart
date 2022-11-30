import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gaitr/app_styles.dart';
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
  late VideoEditorController _c;
  late Key trimmerKey = const Key("0");

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _c = VideoEditorController.file(widget.file,
        maxDuration: const Duration(seconds: 60))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void logGaitVelocityStats(Duration duration) {
    final double milliseconds = duration.inMilliseconds.toDouble();
    patientData.measurementDuration =
        double.parse((milliseconds / 1000).toStringAsPrecision(3));
    patientData.velocity = (10 / (milliseconds / 1000)).toStringAsPrecision(2);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppStyles.transparent,
        border: Border.all(color: AppStyles.transparent),
        middle: AnimatedBuilder(
          animation: _c.video,
          builder: (_, __) {
            final duration = _c.video.value.duration.inMilliseconds;
            // final pos = _editorController.trimPosition * duration;
            final start = _c.minTrim * duration;
            final end = _c.maxTrim * duration;

            return Padding(
                padding: EdgeInsets.symmetric(horizontal: height / 4),
                child: OpacityTransition(
                  visible: true,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(formatter(Duration(milliseconds: start.toInt()))),
                    const SizedBox(width: 10),
                    const Text("-"),
                    const SizedBox(width: 10),
                    Text(formatter(Duration(milliseconds: end.toInt()))),
                  ]),
                ));
          },
        ),
      ),
      child: _c.initialized
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
                          if (_c.isPlaying) {
                            _c.video.pause();
                          } else {
                            _c.video.play();
                          }
                        },
                        child: VideoPlayer(_c.video),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          trimIndexButton(false, false),
                          const SizedBox(width: 10),
                          trimIndexButton(true, false),
                          const SizedBox(width: 20),
                          SizedBox(
                            height: height,
                            width: MediaQuery.of(context).size.width / 3,
                            child: TrimSlider(
                              key: trimmerKey,
                              controller: _c,
                            ),
                          ),
                          const SizedBox(width: 20),
                          trimIndexButton(false, true),
                          const SizedBox(width: 10),
                          trimIndexButton(true, true),
                          const SizedBox(width: 20),
                          CupertinoButton(
                              padding: const EdgeInsets.only(
                                  top: 1, bottom: 1, right: 20, left: 20),
                              color: CupertinoColors.link,
                              child: SizedBox(
                                  height: height,
                                  child: const Center(
                                    child: Text(
                                      "Analyze",
                                      style: AppStyles.buttonLabelStyle,
                                    ),
                                  )),
                              onPressed: () {
                                final _duration = _c.endTrim - _c.startTrim;

                                _c.video.pause().then((_) {
                                  logGaitVelocityStats(_duration);
                                  consentDialog(
                                      context,
                                      "Save Sample?",
                                      "Final time was ${formatter(_duration)} seconds",
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
                  animation: _c.video,
                  builder: (_, __) => OpacityTransition(
                    visible: !_c.isPlaying,
                    child: GestureDetector(
                      onTap: _c.video.play,
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

  CupertinoButton trimIndexButton(bool isForward, bool isMax) {
    final IconData icon =
        isForward ? CupertinoIcons.right_chevron : CupertinoIcons.left_chevron;

    return CupertinoButton(
      padding: const EdgeInsets.only(top: 1, bottom: 1, right: 10, left: 10),
      child: Icon(icon),
      color: AppStyles.brandTertiaryOrange,
      onPressed: () {
        _c.video.pause();
        setState(() {
          if (isMax && isForward && _c.maxTrim < 0.95) {
            _c.updateTrim(_c.minTrim, _c.maxTrim + 0.05);
            _c.video
                .seekTo(Duration(milliseconds: _c.endTrim.inMilliseconds - 50));
          } else if (isMax && !isForward && (_c.maxTrim - _c.minTrim > 0.1)) {
            _c.updateTrim(_c.minTrim, _c.maxTrim - 0.05);
            _c.video.seekTo(
                Duration(milliseconds: _c.endTrim.inMilliseconds - 100));
          } else if (!isMax && isForward && (_c.maxTrim - _c.minTrim > 0.1)) {
            _c.updateTrim(_c.minTrim + 0.05, _c.maxTrim);
            _c.video.seekTo(_c.startTrim);
          } else if (!isMax && !isForward && _c.minTrim > 0.05) {
            _c.updateTrim(_c.minTrim - 0.05, _c.maxTrim);
            _c.video.seekTo(_c.startTrim);
          }

          trimmerKey = Key((_c.maxTrim - _c.minTrim).toString());
        });
      },
    );
  }

  String formatter(Duration duration) => [
        duration.inSeconds.remainder(99).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0')[0]
      ].join(".");
}
