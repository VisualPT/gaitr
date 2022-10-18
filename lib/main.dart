//TO ADD FLUTTER TO PATH, PUT THIS IN THE TERMINAL
//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:flutter/material.dart';
import 'package:gaiter/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

//TODO Optimize camera startup time
//TODO Generate PDF
//Setup ios build (payment)

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
