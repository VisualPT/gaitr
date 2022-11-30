import 'package:flutter/cupertino.dart';
import 'package:gaitr/app_styles.dart';
import 'package:gaitr/components/fancy_plasma.dart';

class LoadingPage extends StatelessWidget {
  final String message;
  final bool isLoading;
  const LoadingPage(
      {super.key, required this.message, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const FancyPlasmaWidget(),
          Center(
            child: SizedBox(
              width: screenSize.width / 2,
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("gaitr-logo.png"),
                  fit: BoxFit.fitWidth,
                )),
              ),
            ),
          ),
          Positioned(
              bottom: screenSize.height / 3,
              child: Center(
                child: Column(
                  children: [
                    Text(message, style: AppStyles.titleTextStyle),
                    if (isLoading) const CupertinoActivityIndicator()
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
