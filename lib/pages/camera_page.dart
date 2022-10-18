import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaiter/config.dart';

import '../cubit/camera/camera_cubit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    //TODO  "Requires full screen" to true in the Xcode Deployment Info.
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraCubit()..initCamera(),
      child: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: state is CameraRecording || state is CameraStandby
                    ? stopwatchWidget(context, state)
                    : null,
              ),
              body: state is CameraError
                  ? Center(
                      child: Column(
                        children: [
                          Text(state.exception.toString()),
                          ElevatedButton(
                              onPressed: () =>
                                  BlocProvider.of<CameraCubit>(context)
                                    ..initCamera,
                              child: const Text("Retry"))
                        ],
                      ),
                    )
                  : cameraWidget(context, state));
        },
      ),
    );
  }

  List<Widget> stopwatchWidget(BuildContext context, CameraState state) {
    return [
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
                  (() {
                    if (state is CameraRecording) {
                      return formatter(state.duration);
                    } else {
                      return formatter(const Duration(seconds: 0));
                    }
                  }()),
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
    ];
  }

  Widget cameraWidget(BuildContext context, CameraState state) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: (() {
        if (state is CameraRecording) {
          return [
            FractionallySizedBox(
                widthFactor: 1, child: CameraPreview(state.controller)),
            GestureDetector(
              onTap: () => BlocProvider.of<CameraCubit>(context)
                  .triggerState(context, state),
              child: const Icon(
                Icons.stop,
                color: Colors.red,
                size: 80,
              ),
            ),
          ];
        } else if (state is CameraStandby) {
          return [
            FractionallySizedBox(
                widthFactor: 1, child: CameraPreview(state.controller)),
            GestureDetector(
              onTap: () => BlocProvider.of<CameraCubit>(context)
                  .triggerState(context, state),
              child: const Icon(
                Icons.circle,
                color: Colors.white,
                size: 80,
              ),
            ),
          ];
        } else {
          return [const Center(child: CircularProgressIndicator())];
        }
      }()),
    );
  }

  String formatter(Duration duration) => [
        duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
        duration.inMilliseconds.remainder(60).toString().padLeft(2, '0')[0]
      ].join(".");
}
