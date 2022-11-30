import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  AppStyles._();

  static const Color transparent = Color(0x00000000);
  static const Color black = CupertinoColors.black;
  static const Color white = CupertinoColors.white;
  static const Color brandPrimary = Color(0xFF0091DA);
  static const Color brandSecondaryDark = Color(0xFF1B365D);
  static const Color brandTertiaryOrange = Color(0xFFEC7723);

  static const TextStyle inputPlaceholderStyle =
      TextStyle(fontWeight: FontWeight.w200, color: black);

  static const TextStyle inputTextStyle =
      TextStyle(fontWeight: FontWeight.w400, color: black);

  static const TextStyle inputPromptStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: CupertinoColors.label,
      fontSize: 15.0);

  static const TextStyle buttonLabelStyle = TextStyle(fontSize: 30);

  static const TextStyle titleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static TextStyle timerTextStyle = GoogleFonts.robotoMono(
      fontWeight: FontWeight.bold, fontSize: 20, color: white.withOpacity(0.8));

}
