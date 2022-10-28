import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gaiter/patient_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool formIsVisible = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text("Gaiter"),
            trailing: CupertinoButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                child: const Icon(CupertinoIcons.settings))),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                CupertinoButton(
                  color: CupertinoColors.link,
                  child: const Text("New Patient"),
                  onPressed: () =>
                      setState(() => formIsVisible = !formIsVisible),
                ),
                if (formIsVisible) const PatientForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
