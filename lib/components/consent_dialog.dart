import 'package:flutter/cupertino.dart';

Future<void> consentDialog(
    BuildContext context,
    String title,
    String content,
    String secondaryAction,
    String primaryAction,
    Function() secondaryCallback,
    Function() primaryCallback) {
  return showCupertinoModalPopup(
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoButton(
            color: CupertinoColors.secondaryLabel,
            onPressed: secondaryCallback,
            child: Text(secondaryAction),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoButton(
            color: CupertinoColors.link,
            onPressed: primaryCallback,
            child: Text(primaryAction),
          ),
        ),
      ],
    ),
  );
}
