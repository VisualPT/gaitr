part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent({required this.duration});
  final Duration duration;

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration}) : super(duration: duration);
  @override
  final Duration duration;

  @override
  List<Object> get props => [duration];
}

class TimerReset extends TimerEvent {
  const TimerReset({required this.duration}) : super(duration: duration);

  @override
  final Duration duration;

  @override
  List<Object> get props => [duration];
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration}) : super(duration: duration);
  @override
  final Duration duration;

  @override
  List<Object> get props => [duration];
}
