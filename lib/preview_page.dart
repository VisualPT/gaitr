import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'storageHelper.dart';

import 'models/ModelProvider.dart';

class PreviewPage extends StatefulWidget {
  final String filePath;
  final double duration;
  final String datetime;

  const PreviewPage(
      {Key? key,
      required this.filePath,
      required this.duration,
      required this.datetime})
      : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late VideoPlayerController _videoPlayerController;
  final distanceFactor = 10 / 3.281;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  Future<void> _saveData() async {
    uploadFile(File(widget.filePath));
    Patient newPatient = Patient(
        velocity: distanceFactor / widget.duration,
        age: 10,//TODO get patient info
        duration: widget.duration,
        datetime: TemporalDateTime.fromString(widget.datetime));
    try {
      await Amplify.DataStore.save(newPatient);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview and Confirm'),
      ),
      extendBodyBehindAppBar: false,
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: FutureBuilder(
                future: _initVideoPlayer(),
                builder: (context, state) {
                  if (state.hasError) {
                    print("Something went wrong");
                  }
                  if (state.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return VideoPlayer(_videoPlayerController);
                  }
                },
              ),
            ),
            FractionallySizedBox(
              heightFactor: 0.3,
              child: ColoredBox(
                color: Colors.white.withAlpha(100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (distanceFactor / widget.duration)
                              .toString()
                              .substring(0, 5),
                          style: TextStyle(color: Colors.black, fontSize: 60),
                        ),
                        Text(
                          'm/s',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Text(
                      (distanceFactor / widget.duration) > 1.0
                          ? "No fall concerns"
                          : "At risk of falling",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FloatingActionButton(
            onPressed: () {
              //This is where the data should be sent to the EMR
              _saveData();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            tooltip: 'Send to EMR and go to home screen',
            child: const Icon(Icons.send_and_archive_outlined),
          ),
        ]),
        color: Colors.blue,
      ),
    );
  }
}
