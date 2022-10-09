import 'package:flutter/material.dart';
import 'package:helpers/helpers/transition.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

//TODO create PDF and export features
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;
  final double height = 60;

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    super.dispose();
  }

  void _exportVideo() async {
    _exportingProgress.value = 0;
    _isExporting.value = true;
    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
    await _controller.exportVideo(
      preset: VideoExportPreset.medium,
      customInstruction: "-crf 17",
      onProgress: (stats, value) => _exportingProgress.value = value,
      onError: (e, s) => _exportText = "Error on export video :(",
      onCompleted: (file) {
        _isExporting.value = false;
        if (!mounted) return;

        final VideoPlayerController videoController =
            VideoPlayerController.file(file);
        videoController.initialize().then((value) async {
          setState(() {});
          videoController.play();
          videoController.setLooping(true);
          await showDialog(
            context: context,
            builder: (_) => Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: AspectRatio(
                  aspectRatio: videoController.value.aspectRatio,
                  child: VideoPlayer(videoController),
                ),
              ),
            ),
          );
          await videoController.pause();
          videoController.dispose();
        });

        _exportText = "Video success export!";
        setState(() => _exported = true);
        Future.delayed(const Duration(seconds: 2),
            () => setState(() => _exported = false));
      },
    );
  }

  //TODO Fix
  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        axisAlignment: 1.0,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Text(_exportText,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ValueListenableBuilder(
      valueListenable: _isExporting,
      builder: (_, bool export, __) => OpacityTransition(
        visible: export,
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: ValueListenableBuilder(
            valueListenable: _exportingProgress,
            builder: (_, double value, __) => Text(
              "Exporting video ${(value * 100).ceil()}%",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
