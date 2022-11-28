import 'package:flutter/cupertino.dart';
import 'package:gaitr/app_styles.dart';
import 'package:simple_animations/simple_animations.dart';

class FancyPlasmaWidget extends StatelessWidget {
  const FancyPlasmaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppStyles.brandPrimary,
            AppStyles.brandSecondaryDark,
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 10,
        color: CupertinoColors.systemBlue.withOpacity(0.4),
        blur: 0.4,
        size: 1,
        speed: 6.35,
        offset: 0,
        blendMode: BlendMode.plus,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: 3.14 / 2,
      ),
    );
  }
}
