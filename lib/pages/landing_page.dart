import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gaitr/components/fancy_plasma.dart';
import 'package:gaitr/models/patient_data.dart';
import 'package:gaitr/components/patient_form.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    setPreferences();
    super.initState();
  }

  void setPreferences() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO be smarter with this
      onTapDown: ((_) => setPreferences()),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          //TODO set to fyzical colors
          FancyPlasmaWidget(color: CupertinoColors.systemBlue.withOpacity(0.4)),
          Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "gaitr-logo.png",
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/settings"),
                          child: const Icon(CupertinoIcons.settings),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
                    const Spacer(flex: 3),
                    ...measurementMethodToggle(),
                    PatientForm(patientData.isVideo),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> measurementMethodToggle() {
    return [
      const Text('How will you test today?',
          style: TextStyle(
              color: CupertinoColors.label, fontWeight: FontWeight.bold)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CupertinoButton(
              child: Icon(
                CupertinoIcons.videocam_circle,
                semanticLabel: "Video Camera Icon",
                size: patientData.isVideo ? 128.0 : 72.0,
                color: patientData.isVideo
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.inactiveGray,
                shadows: const [
                  Shadow(blurRadius: 50.0),
                  Shadow(blurRadius: 10.0, offset: Offset(3, 4))
                ],
              ),
              onPressed: () => setState(() => patientData.isVideo = true),
            ),
            const Spacer(),
            CupertinoButton(
              child: Icon(
                CupertinoIcons.stopwatch,
                semanticLabel: "Stop Watch Icon",
                size: patientData.isVideo ? 72.0 : 128.0,
                color: patientData.isVideo
                    ? CupertinoColors.inactiveGray
                    : CupertinoColors.activeBlue,
                shadows: const [
                  Shadow(blurRadius: 50.0),
                  Shadow(blurRadius: 10.0, offset: Offset(3, 4))
                ],
              ),
              onPressed: () => setState(
                () => patientData.isVideo = false,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    ];
  }
}
