import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';

import 'package:gaiter/pages/editor_page.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  Timer? timer;
  late Duration duration = const Duration(seconds: 0);

  CameraCubit() : super(CameraLoading());
  void startTimer(CameraController controller) {
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      duration = Duration(milliseconds: duration.inMilliseconds + 10);

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
    try {
      if (state is CameraRecording) {
        print(duration);
        resetTimer();
        XFile file = await state.controller.stopVideoRecording();
        MaterialPageRoute route = MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => EditorPage(file: File(file.path)));
        Navigator.push(context, route);
        initCamera();
      } else if (state is CameraStandby) {
        startTimer(state.controller);
        state.controller.startVideoRecording();
      }
    } on Exception catch (e) {
      resetTimer();
      emit(CameraError(exception: e));
    }
  }
}