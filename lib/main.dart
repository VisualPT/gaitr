//TO ADD FLUTTER TO PATH, PUT THIS IN THE TERMINAL
//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:flutter/material.dart';
import 'camera_page.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const HomePage(title: 'Gaiter - Velocity Detection'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'a two-click tool',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'for gait velocity',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'detection and logging',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Press icon to begin',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CameraPage();
              }));
            },
            tooltip: 'Take Video',
            child: const Icon(Icons.video_camera_back_rounded),
          ),
        ]),
        color: Colors.blue,
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
