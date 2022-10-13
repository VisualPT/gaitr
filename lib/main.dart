//TO ADD FLUTTER TO PATH, PUT THIS IN THE TERMINAL
//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaiter/config.dart';
import 'package:gaiter/form.dart';

void main() {
  runApp(const MyApp());
}

//TODO Optimize camera startup time
//TODO Generate PDF

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaiter - Gait Velocity Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

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
