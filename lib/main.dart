//TO ADD FLUTTER TO PATH, PUT THIS IN THE TERMINAL
//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:flutter/material.dart';
import 'camera_page.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';


void main() {
  runApp(const MyApp());
}

//Current: Collect basic user info
//TODO Optimize camera startup time
//TODO Generate PDF
//TODO Research and follow proper naming and placement conventions

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

  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  final AmplifyStorageS3 _storagePlugin = AmplifyStorageS3();
  
  @override
  void initState() {
    _initializeApp();

    super.initState();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins(
          [_dataStorePlugin, _apiPlugin, _authPlugin, _storagePlugin]);
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print('An error occurred while configuring Amplify: $e');
    }
  }

   Future<void> _initializeApp() async {
    await _configureAmplify();

    //FOR LIVE UPDATES
    // DataStore.observeQuery() will emit an initial QuerySnapshot in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
    /*
    _subscription = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _todos = snapshot.items;
      });
    });
    */
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaiter - Velocity Detection'),
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
