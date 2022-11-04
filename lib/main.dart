//TO ADD FLUTTER TO PATH, PUT THIS IN THE TERMINAL
//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaiter/config.dart';
import 'package:gaiter/pages/pages.dart';

void main() {
  runApp(const Root());
}

//TODO Email user PDF
//TODO Styling
//TODO Ios app store (payment)

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: CupertinoApp(
        title: 'Gaiter',
        builder: Authenticator.builder(),
        routes: {
          "/": (context) => const LandingPage(),
          "/form": (context) => const FormPage(),
          "/measure/camera": (context) => const CameraPage(),
          "/measure/stopwatch": (context) => const StopwatchPage(),
          "/confirm": (context) => const ArchivePage(),
          "/settings": (context) => const SettingsPage(),
        },
      ),
    );
  }
}
