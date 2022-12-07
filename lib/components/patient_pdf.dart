//DO NOT IMPORT material.dart without renaming it with <as> keyword, will conflict with pdf/widgets.dart
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:gaitr/models/patient_data.dart';

class PatientPdf {
  late Font baseFont;
  late Font boldFont;
  late Font italicFont;
  late Font boldItalicFont;

  late PdfColor primaryColor;
  late PdfColor secondaryColor;
  late PdfColor black;

  late BorderSide borderSide;

  final double inch = 72.0;
  final double halfinch = 36.0;

  late TextStyle header;
  late TextStyle headerItalic;
  late TextStyle subTitle;
  late TextStyle detail;
  late TextStyle detailBold;
  late TextStyle subHeader;
  late TextStyle disclaimer;

  Future<void> configPdfStyles() async {
    baseFont = await PdfGoogleFonts.openSansRegular();
    boldFont = await PdfGoogleFonts.openSansBold();
    italicFont = await PdfGoogleFonts.openSansItalic();
    boldItalicFont = await PdfGoogleFonts.openSansBoldItalic();

    primaryColor = PdfColor.fromHex('#008ed6');
    secondaryColor = PdfColor.fromHex('#24446c');
    black = PdfColors.black;

    borderSide = BorderSide(width: 2, color: secondaryColor);

    header = TextStyle(font: boldFont, fontSize: 30.0, lineSpacing: 2.0);
    headerItalic =
        TextStyle(font: boldItalicFont, fontSize: 30.0, lineSpacing: 2.0);
    subTitle = TextStyle(font: boldFont, fontSize: 20.0, lineSpacing: 2.0);
    detail = TextStyle(font: baseFont, fontSize: 15.0, lineSpacing: 2.0);
    detailBold = TextStyle(font: boldFont, fontSize: 15.0, lineSpacing: 2.0);
    subHeader = TextStyle(font: boldFont, fontSize: 50.0, lineSpacing: 2.0);
    disclaimer = TextStyle(font: baseFont, fontSize: 10.0, lineSpacing: 2.0);
    return;
  }

  Future<Uint8List> generatePdf(PatientData patentData) async {
    await configPdfStyles();
    //final fyzLogo = await rootBundle.loadString('assets/fyzical-logo.svg');
    final gaitrLogo = await rootBundle.loadString('assets/gaitr-logo.svg');

    final pdf = Document(
        title: patientData.lastname +
            patientData.firstname +
            patientData.age.toString(),
        creator: "gaitr Systems");

    pdf.addPage(
      Page(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: EdgeInsets.all(halfinch),
        ),
        build: (Context context) => SizedBox(
          height: 11 * inch,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Header(
                child: Column(children: [
              SizedBox(
                height: inch,
                width: 8.5 * inch,
                child: Center(
                  child: SvgImage(svg: gaitrLogo, fit: BoxFit.fitHeight),
                ),
              ),
              RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Gait Velocity Analysis", style: header),
                    ],
                  ),
                  overflow: TextOverflow.span),
            ])),
            SizedBox(
              height: 3 * inch,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: disclaimer,
                            text:
                                "A distance of 10 meters is measured over a level surface with 2 meters for acceleration and 2 meters for deceleration.")),
                    Spacer(flex: 2),
                    SizedBox(
                        height: 0.65 * inch,
                        child: Row(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Patient Name: ", style: detail),
                                    TextSpan(
                                        text:
                                            "${patientData.firstname} ${patientData.lastname}",
                                        style: detailBold),
                                  ]),
                                ),
                                Spacer(),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Birth Date: ", style: detail),
                                    TextSpan(
                                        text: patientData.bday,
                                        style: detailBold),
                                  ]),
                                ),
                              ]),
                          Spacer(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: "Date: ", style: detail),
                                  TextSpan(
                                      text: patientData.date,
                                      style: detailBold),
                                ])),
                                Spacer(),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: "Time: ", style: detail),
                                  TextSpan(
                                      text: patientData.time,
                                      style: detailBold),
                                ])),
                              ]),
                        ])),
                    Spacer(),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "Age: ", style: detail),
                        TextSpan(text: patientData.age, style: detailBold),
                      ]),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "Gender: ", style: detail),
                        TextSpan(
                            text: patientData.isMale ? "Male" : "Female",
                            style: detailBold),
                      ]),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "Measurement Method: ", style: detail),
                        TextSpan(
                            text: patientData.isVideo ? "Video" : "Stopwatch",
                            style: detailBold),
                      ]),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "Measurement Duration: ", style: detail),
                        TextSpan(
                            text: patientData.measurementDuration
                                .toStringAsPrecision(3),
                            style: detailBold),
                        TextSpan(text: " seconds", style: detail),
                      ]),
                    ),
                    Spacer(),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "Gait Velocity: ", style: detail),
                      TextSpan(text: patientData.velocity, style: detailBold),
                      TextSpan(text: " meters/second", style: detail),
                    ])),
                  ]),
            ),
            Spacer(),
            SizedBox(
              height: 0.75 * inch,
              child: Row(children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    SizedBox(
                      height: inch * 1,
                      width: inch * 5,
                      child: Column(children: [
                        Container(
                          height: inch * 0.25,
                          width: inch * 5,
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                PdfColor.fromHex("#1b365d"),
                                PdfColor.fromHex("#1d3d68"),
                                PdfColor.fromHex("#1f4573"),
                                PdfColor.fromHex("#214d7e"),
                                PdfColor.fromHex("#225589"),
                                PdfColor.fromHex("#22659f"),
                                PdfColor.fromHex("#206eab"),
                                PdfColor.fromHex("#1d76b7"),
                                PdfColor.fromHex("#197fc2"),
                                PdfColor.fromHex("#1088ce"),
                                PdfColor.fromHex("#0091da"),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: axisLabel(),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: disclaimer, text: "Gait Velocity (m/s)"),
                        ),
                        Spacer(),
                      ]),
                    ),
                    Positioned(
                      top: 0.1,
                      left: positioner(patientData.velocity),
                      child: Container(
                        height: 0.25 * inch,
                        width: 0.25 * inch,
                        decoration: BoxDecoration(
                            color: PdfColor.fromRYB(1, 0, 0),
                            shape: BoxShape.circle),
                      ),
                    ),
                    Positioned(
                      top: 0.1,
                      left: positioner(AgeGenderNorms.getVelocityFromAge(
                              patientData.isMale, int.parse(patientData.age))
                          .toString()),
                      child: Container(
                        height: 0.25 * inch,
                        width: 0.25 * inch,
                        decoration: BoxDecoration(
                            color: PdfColor.fromRYB(0, 1, 1),
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(2.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                height: 0.25 * inch,
                                width: 0.25 * inch,
                                decoration: BoxDecoration(
                                    color: PdfColor.fromRYB(1, 0, 0),
                                    shape: BoxShape.circle),
                              ),
                              Text(" - Patient"),
                            ]),
                            Spacer(),
                            Row(children: [
                              Container(
                                height: 0.25 * inch,
                                width: 0.25 * inch,
                                decoration: BoxDecoration(
                                    color: PdfColor.fromRYB(0, 1, 1),
                                    shape: BoxShape.circle),
                              ),
                              Text(" - Average Peer"),
                            ]),
                            Spacer(),
                          ]),
                    ))
              ]),
            ),
            Spacer(),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: detailBold,
                  text: getComparisonMessage(double.parse(patientData.velocity),
                      patientData.isMale, int.parse(patientData.age)),
                ),
              ),
            ),
            Spacer(flex: 2),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: subTitle,
                    text: double.parse(patientData.velocity) < 1
                        ? "Needs intervention to reduce risk of fall"
                        : "Low likelihood of experiencing a fall"),
              ),
            ),
            Spacer(flex: 4),
            Footer(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text: const TextSpan(text: " ")),
                    RichText(
                        text: TextSpan(
                            style: disclaimer,
                            text: "© 2022 Gaitr Measurement Softwares")),
                    RichText(
                        text: TextSpan(
                            style: disclaimer,
                            text: "No Distribution without Permission")),
                    RichText(
                        text: TextSpan(
                            style: disclaimer,
                            text:
                                "Reference: Fritz, Stacy & Lusardi, Michelle. (2009).\n Walking speed: The sixth vital sign. J Geriatr Phys Ther. 32. 46-49. "))
                  ]),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                      text: TextSpan(
                          style: disclaimer,
                          text: "Minimal Detectable Change: 0.1m/sec")),
                  RichText(
                      text: TextSpan(
                          style: disclaimer,
                          text:
                              "Minimum Clinically Important Difference: 0.1m/sec")),
                  RichText(
                      text: TextSpan(
                          style: disclaimer,
                          text: "Test/Re-test Reliability: ICC > 0.7"))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
    return pdf.save();
  }

  List<Widget> axisLabel() {
    final values = List<double>.generate(9, (i) => i * 0.2)
        .map<Text>((value) => value >= 1.0
            ? Text(value.toStringAsPrecision(2))
            : Text(value.toStringAsPrecision(1)))
        .toList();
    return List<Widget>.generate(
        17, (i) => i % 2 == 0 ? values[i ~/ 2] : Spacer());
  }

  double positioner(String velocity) =>
      (2.95 * inch * double.parse(velocity)).clamp(0 * inch, 4.75 * inch);
}

String getComparisonMessage(double velocity, bool isMale, int age) {
  double percent =
      AgeGenderNorms.getPercentDifferenceFromNorm(velocity, isMale, age);
  int _index = (age / 10).round();
  String speedComparison = percent > 0 ? "faster" : "slower";
  String ageRange = _index > 8 ? "80+" : "${_index}0 - ${_index}9";
  return percent.abs() > 5.0
      ? "Among $ageRange year olds, you are ${percent.abs()}% $speedComparison than average."
      : "Your gait velocity matches your peer group aged $ageRange.";
}
