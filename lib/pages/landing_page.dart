import 'package:flutter/cupertino.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text("Gaiter")),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width,
              child: const Positioned.fill(
                child: Image(
                  image: AssetImage("fyzman-black-icon.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CupertinoButton(
                color: CupertinoColors.link,
                child: const Text("New Patient"),
                onPressed: () => Navigator.pushNamed(context, "/form")),
          ],
        ));
  }
}






// child: Container(
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("fyzman-black-icon.png"),
//                 fit: BoxFit.fitHeight)),
//         child: Container(
//           alignment: Alignment.bottomCenter,
//           child: CupertinoButton(
//               color: CupertinoColors.link,
//               child: const Text("New Patient"),
//               onPressed: () => Navigator.pushNamed(context, "/form")),
//         ),
//       ),