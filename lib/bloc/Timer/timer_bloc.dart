import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gaitr/models/patient_data.dart';
import 'package:gaitr/bloc/Timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }

  final Ticker _ticker;
  static const Duration _duration = Duration(milliseconds: 0);

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration.inMilliseconds)
        .listen((duration) =>
            add(TimerTicked(duration: Duration(milliseconds: duration))));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    final double seconds = event.duration.inMilliseconds / 1000;
    patientData.measurementDuration = seconds;
    patientData.velocity = (10 / seconds).toStringAsPrecision(2);

    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
  }
}
