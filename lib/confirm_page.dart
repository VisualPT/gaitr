import 'package:flutter/material.dart';

class ConfirmPage extends StatefulWidget {
  final double duration;
  const ConfirmPage({Key? key, required this.duration}) : super(key: key);

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  var distanceFactor = 10 / 3.281;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Subject gait velocity:',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              (distanceFactor / widget.duration).toString().substring(0, 5),
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              'm/s',
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                (distanceFactor / widget.duration) > 1.0
                    ? "No fall concerns"
                    : "At risk of falling",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //This is where the data should be sent to the EMR
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        tooltip: 'Back to Home Screen',
        child: const Icon(Icons.send_and_archive_outlined),
      ),
    );
  }
}
