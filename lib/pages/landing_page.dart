import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gaitr/app_styles.dart';
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
          const FancyPlasmaWidget(),
          Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "gaitr-logo.png",
                  ),
                  fit: BoxFit.scaleDown),
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
      const Text('How will you test today?', style: AppStyles.inputPromptStyle),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            measurementMethod(CupertinoIcons.videocam_circle),
            const Spacer(),
            measurementMethod(CupertinoIcons.stopwatch),
            const Spacer(),
          ],
        ),
      ),
    ];
  }

  Widget measurementMethod(IconData icon) {
    late Color _color = AppStyles.transparent;
    if (icon == CupertinoIcons.videocam_circle && patientData.isVideo) {
      _color = AppStyles.brandTertiaryOrange;
    } else if (icon == CupertinoIcons.stopwatch && !patientData.isVideo) {
      _color = AppStyles.brandTertiaryOrange;
    }
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
                center: const Alignment(0, 0.07),
                colors: [_color, AppStyles.transparent],
                stops: const [0.5, 0.8])),
        child: CupertinoButton(
            child: Icon(icon,
                size: MediaQuery.of(context).size.height * 0.10,
                color: CupertinoColors.black),
            onPressed: () => setState(() => patientData.isVideo =
                icon == CupertinoIcons.videocam_circle ? true : false)));
  }
}
