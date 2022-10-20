import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaiter/cubit/pdf/pdf_cubit.dart';
import 'package:gaiter/patient_pdf.dart';
import 'package:helpers/helpers/transition.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

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
  void initState() {
    //TODO  "Requires full screen" to true in the Xcode Deployment Info.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

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
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
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

        setState(() => _exported = true);
        Future.delayed(const Duration(seconds: 2),
            () => setState(() => _exported = false));
      },
    );
  }

  //TODO Hook up with download button
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
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: buildPdf(context)));
  }

  Widget buildPdf(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => PdfCubit()..initPDFView(),
      child: BlocBuilder<PdfCubit, PdfState>(
        builder: (context, state) {
          if (state is PdfLoaded) {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 50,
                    width: MediaQuery.of(context).size.width,
                    child: state.pdfView,
                  ), 
                  ElevatedButton(
                      onPressed: BlocProvider.of<PdfCubit>(context).initPDFView,
                      child: const Text("retry"))
                ],
              ),
            );
          } else if (state is PdfLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PdfError) {
            return Center(
              child: Text(state.exception.toString()),
            );
          } else {
            return const Center(
              child: Text("Invalid PDF State"),
            );
          }
        },
      ),
    ));
  }
}

// Column(
        //children: [
          // IconButton(
          //   onPressed: _exportVideo,
          //   icon: const Icon(Icons.save),
          // )
          // ValueListenableBuilder(
          //   valueListenable: _isExporting,
          //   builder: (_, bool export, __) => OpacityTransition(
          //     visible: export,
          //     child: AlertDialog(
          //       backgroundColor: Colors.white,
          //       title: ValueListenableBuilder(
          //         valueListenable: _exportingProgress,
          //         builder: (_, double value, __) => Text(
          //           "Exporting video ${(value * 100).ceil()}%",
          //           style: const TextStyle(
          //             color: Colors.black,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 14,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
       // ],
     // ),