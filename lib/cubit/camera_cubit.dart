import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gaiter/editor_page.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  Timer? timer;
  late Duration duration = const Duration(seconds: 0);

  CameraCubit() : super(CameraLoading());
  void startTimer(CameraController controller) {
    timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      duration = Duration(milliseconds: duration.inMilliseconds + 1);

      emit(CameraRecording(controller: controller, duration: duration));
    });
  }

  void resetTimer() {
    timer?.cancel();
    duration = const Duration(seconds: 0);
  }

  void initCamera() async {
    try {
      final cameras = await availableCameras();
      final cameraController = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back),
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      await cameraController.initialize();
      await cameraController
          .lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      await cameraController.prepareForVideoRecording();
      emit(CameraStandby(controller: cameraController));
    } on Exception catch (e) {
      emit(CameraError(exception: e));
    }
  }

  void triggerState(BuildContext context, CameraState state) async {
    print("triggered");
    if (state is CameraRecording) {
      XFile file = await state.controller.stopVideoRecording();
      MaterialPageRoute route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => EditorPage(file: File(file.path)));
      Navigator.push(context, route);
      initCamera();
      resetTimer();
    } else if (state is CameraStandby) {
      state.controller.startVideoRecording();
      startTimer(state.controller);
    }
  }
}
