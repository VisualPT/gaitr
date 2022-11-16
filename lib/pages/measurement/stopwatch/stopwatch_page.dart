import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gaitr/bloc/Timer/ticker.dart';
import 'package:gaitr/bloc/Timer/timer_bloc.dart';
import 'package:gaitr/components/fancy_plasma.dart';
import 'package:gaitr/models/patient_data.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TimerBloc(ticker: const Ticker()),
        child: CupertinoPageScaffold(
          child: Stack(alignment: Alignment.topCenter, children: [
            FancyPlasmaWidget(
                color: CupertinoColors.systemBlue.withOpacity(0.4)),
            SafeArea(
              child: Text(
                "${patientData.firstname} ${patientData.lastname} Gait Eval",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TimeBubble(state: state),
                    Actions(state: state),
                  ]);
            }),
          ]),
        ));
  }
}

class TimeBubble extends StatelessWidget {
  final TimerState state;
  const TimeBubble({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: state is TimerInitial
              ? CupertinoColors.systemGrey.withOpacity(0.4)
              : CupertinoColors.systemGreen.withOpacity(0.4)),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            formatter(state.duration),
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class Actions extends StatelessWidget {
  final TimerState state;
  const Actions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: FittedBox(
          fit: BoxFit.fill,
          child: () {
            if (state is TimerInitial) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(CupertinoIcons.play_circle,
                    color: CupertinoColors.systemGreen.darkColor),
                onPressed: () => context
                    .read<TimerBloc>()
                    .add(TimerStarted(duration: state.duration)),
              );
            }
            if (state is TimerRunInProgress) {
              return CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.stop_circle,
                    color: CupertinoColors.systemRed,
                  ),
                  onPressed: () {
                    context
                        .read<TimerBloc>()
                        .add(TimerReset(duration: state.duration));
                    Navigator.pushNamed(context, "/confirm");
                  });
            }
          }(),
        ));
  }
}

String formatter(Duration duration) => [
      duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
      duration.inMilliseconds.remainder(60).toString().padLeft(2, '0')[0]
    ].join(".");
