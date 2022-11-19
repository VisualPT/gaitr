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
    detail = TextStyle(font: baseFont, fontSize: 15.0, lineSpacing: 2.0);
    detailBold = TextStyle(font: boldFont, fontSize: 15.0, lineSpacing: 2.0);
    subHeader = TextStyle(font: boldFont, fontSize: 50.0, lineSpacing: 2.0);
    disclaimer = TextStyle(font: baseFont, fontSize: 10.0, lineSpacing: 2.0);
    return;
  }

  Future<Uint8List> generatePdf(PatientData patentData) async {
    await configPdfStyles();
    final fyzLogo = await rootBundle.loadString('assets/fyzical-logo.svg');
    final gaitrLogo = await rootBundle.loadString('assets/gaitr-logo.svg');
    final walkingChart =
        await rootBundle.loadString('assets/walking-chart.svg');

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
        build: (Context context) => Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Header(
                child: Column(children: [
              SizedBox(
                height: inch,
                child: Row(children: [
                  SvgImage(svg: gaitrLogo, fit: BoxFit.fitHeight),
                  Spacer(),
                  SvgImage(svg: fyzLogo, fit: BoxFit.fitHeight),
                ]),
              ),
              RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Gait Velocity Test & Report", style: header),
                    ],
                  ),
                  overflow: TextOverflow.span),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: "Sampled on: ", style: detail),
                TextSpan(text: patientData.date, style: detailBold),
                TextSpan(text: " at ", style: detail),
                TextSpan(text: patientData.time, style: detailBold),
              ])),
              Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Patient Name: ", style: detail),
                  TextSpan(
                      text: "${patientData.firstname} ${patientData.lastname}",
                      style: detailBold),
                ]),
              ),
              Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Birth Date: ", style: detail),
                  TextSpan(text: patientData.bday, style: detailBold),
                  TextSpan(text: " (", style: detail),
                  TextSpan(text: patientData.age, style: detailBold),
                  TextSpan(text: " y/o)", style: detail),
                ]),
              ),
              Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Measurement Method: ", style: detail),
                  TextSpan(
                      text: patientData.isVideo ? "video" : "stopwatch",
                      style: detailBold),
                ]),
              ),
              Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Measurement Duration (ss.ms): ", style: detail),
                  TextSpan(
                      text: patientData.measurementDuration
                          .toStringAsPrecision(3),
                      style: detailBold),
                ]),
              ),
              Spacer(),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: "Gait Velocity (m/s): ", style: detail),
                TextSpan(text: patientData.velocity, style: detailBold),
              ])),
            ]),
            Spacer(),
            SizedBox(
              height: 4 * inch,
              child: Center(
                child: Stack(children: [
                  SvgImage(svg: walkingChart, fit: BoxFit.fill, clip: false),
                  Positioned(
                    left: positioner(patientData.velocity),
                    child: Container(
                      height: 4.5 * inch,
                      width: 0.01 * inch,
                      decoration:
                          //TODO fyz colors
                          BoxDecoration(
                        color: PdfColor.fromRYB(0, 0, 1, 0.3),
                      ),
                    ),
                  )
                ]),
              ),
            ),
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: disclaimer,
                  text:
                      "A distance of 10 meters is measured over a level surface with 2 meters for acceleration and 2 meters for deceleration."),
            ),
            Spacer(flex: 4),
            Footer(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: disclaimer,
                            text: "© 2022 gaitr Measurement Softwares")),
                    RichText(
                        text: TextSpan(
                            style: disclaimer,
                            text: "No Distribution without Permission")),
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

//TODO debug
  double positioner(String velocity) =>
      (double.parse(velocity) * (2.57 + 1.7) * inch)
          .clamp(1.7 * inch, 5.2 * inch);
}

// final file =
//     File(userData["Last Name"] + userData["FirstName"] + userData["Age"]);
// await file.writeAsBytes(await pdf.save());
