import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          previousPageTitle: "Home",
          middle: Text("Settings"),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  child: const Text("Sign Out"),
                  onPressed: () => Amplify.Auth.signOut(),
                ),
                const Spacer(),
              ],
            ),
          ),
        ));
  }
}
