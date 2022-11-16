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
      onTapDown: ((_) => setPreferences()),
      child: Stack(
        children: [
          FancyPlasmaWidget(color: CupertinoColors.systemBlue.withOpacity(0.4)),
          Container(
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("gaitr-logo.png"),
              fit: BoxFit.fitWidth,
            )),
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
                    SizedBox(height: MediaQuery.of(context).size.height / 2),
                    const Spacer(flex: 4),
                    PatientForm(patientData.isVideo),
                    const Spacer(),
                    CupertinoSwitch(
                      value: patientData.isVideo,
                      onChanged: (bool value) {
                        setState(() {
                          patientData.isVideo = value;
                        });
                      },
                    ),
                    const Text('Toggle Measurement Method',
                        style: TextStyle(
                            color: CupertinoColors.label,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
