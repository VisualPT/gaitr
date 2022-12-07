import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:gaitr/pages/measurement/video/editor_page.dart';

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
      final camera = await availableCameras().then((_cameras) =>
          _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back));
      final cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      await cameraController.initialize();
      await cameraController
          .lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      emit(CameraStandby(controller: cameraController));
    } catch (e) {
      emit(CameraError(exception: Exception(e.toString())));
    }
    //TODO Handle exception when no camera available
  }

  void triggerState(BuildContext context, CameraState state) async {
    try {
      if (state is CameraRecording) {
        resetTimer();
        XFile file = await state.controller.stopVideoRecording();
        CupertinoPageRoute route = CupertinoPageRoute(
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

  void resetCamera() async {
    emit(CameraLoading());
    initCamera();
  }
  //TODO build robust videocamera widget using methods below
}

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);

  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // // #docregion AppLifecycle
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final CameraController? cameraController = widget.controller;

  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }

  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     onNewCameraSelected(cameraController.description);
  //   }
  // }
  //   void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
  //   if (widget.controller == null) {
  //     return;
  //   }

  //   final CameraController cameraController = widget.controller!;

  //   final Offset offset = Offset(
  //     details.localPosition.dx / constraints.maxWidth,
  //     details.localPosition.dy / constraints.maxHeight,
  //   );
  //   cameraController.setExposurePoint(offset);
  //   cameraController.setFocusPoint(offset);
  // }
  //  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
  //   final CameraController? oldController = widget.controller;
  //   if (oldController != null) {
  //     // `controller` needs to be set to null before getting disposed,
  //     // to avoid a race condition when we use the controller that is being
  //     // disposed. This happens when camera permission dialog shows up,
  //     // which triggers `didChangeAppLifecycleState`, which disposes and
  //     // re-creates the controller.
  //     widget.controller = null;
  //     await oldController.dispose();
  //   }

  //   final CameraController cameraController = CameraController(
  //     cameraDescription,
  //     kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
  //     enableAudio: enableAudio,
  //     imageFormatGroup: ImageFormatGroup.jpeg,
  //   );

  //   widget.controller = cameraController;

  //   // If the controller is updated then update the UI.
  //   cameraController.addListener(() {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //     if (cameraController.value.hasError) {
  //       showInSnackBar(
  //           'Camera error ${cameraController.value.errorDescription}');
  //     }
  //   });

  //   try {
  //     await cameraController.initialize();
  //   } on CameraException catch (e) {
  //     switch (e.code) {
  //       case 'CameraAccessDenied':
  //         showInSnackBar('You have denied camera access.');
  //         break;
  //       case 'CameraAccessDeniedWithoutPrompt':
  //         // iOS only
  //         showInSnackBar('Please go to Settings app to enable camera access.');
  //         break;
  //       case 'CameraAccessRestricted':
  //         // iOS only
  //         showInSnackBar('Camera access is restricted.');
  //         break;
  //       case 'AudioAccessDenied':
  //         showInSnackBar('You have denied audio access.');
  //         break;
  //       case 'AudioAccessDeniedWithoutPrompt':
  //         // iOS only
  //         showInSnackBar('Please go to Settings app to enable audio access.');
  //         break;
  //       case 'AudioAccessRestricted':
  //         // iOS only
  //         showInSnackBar('Audio access is restricted.');
  //         break;
  //       default:
  //         _showCameraException(e);
  //         break;
  //     }
  //   }

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }
  //  void showInSnackBar(String message) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(message)));
  // }
