import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaiter/config.dart';
import 'package:gaiter/patient_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    configureAmplify();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'a two-click tool',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'for gait velocity detection and logging',
                style: Theme.of(context).textTheme.headline6,
              ),
              const PatientForm()
            ],
          ),
        ),
      ),
    );
  }
}
