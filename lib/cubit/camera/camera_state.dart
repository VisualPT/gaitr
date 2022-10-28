part of 'camera_cubit.dart';

@immutable
abstract class CameraState {
}

class CameraLoading extends CameraState {}

class CameraRecording extends CameraState {
  final IconData icon = CupertinoIcons.square;
  final CameraController controller;
  final Duration duration;
  CameraRecording({required this.controller, required this.duration});
}

class CameraStandby extends CameraState {
  final IconData icon = CupertinoIcons.circle;
  final CameraController controller;
  CameraStandby({required this.controller});
}

class CameraError extends CameraState {
  final IconData icon = CupertinoIcons.restart;
  final Exception exception;
  CameraError({required this.exception});
}
