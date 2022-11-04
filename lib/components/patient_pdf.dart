//DO NOT IMPORT material.dart without renaming it with <as> keyword, will conflict with pdf/widgets.dart
import 'package:flutter/services.dart';
import 'package:gaiter/models/patient_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PatientPdf {
  late Font baseFont;
  late Font boldFont;
  late Font italicFont;
  late Font boldItalicFont;

  late PdfColor primaryColor;
  late PdfColor secondaryColor;
  late PdfColor black;

  late BorderSide borderSide;

  final int inch = 72;
  final int halfinch = 36;

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

    header = TextStyle(font: boldFont, fontSize: 30.0);
    headerItalic = TextStyle(font: boldItalicFont, fontSize: 30.0);
    detail = TextStyle(font: baseFont, fontSize: 15.0);
    detailBold = TextStyle(font: boldFont, fontSize: 15.0);
    subHeader = TextStyle(font: boldFont, fontSize: 50.0);
    disclaimer = TextStyle(font: baseFont, fontSize: 10.0);
    return;
  }

  Future<Uint8List> generatePdf(PatientData patentData) async {
    await configPdfStyles();
    final logo = await rootBundle.loadString('assets/fyzman-blue.svg');

    final pdf = Document(
        title: patientData.lastname +
            patientData.firstname +
            patientData.age.toString(),
        creator: "Gaiter Systems");

    pdf.addPage(
      Page(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: EdgeInsets.all(halfinch.toDouble()),
          buildBackground: (context) => FullPage(
            ignoreMargins: true,
            child: SvgImage(svg: logo, fit: BoxFit.fitHeight),
          ),
        ),
        build: (Context context) => Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Header(
                child: FittedBox(
              fit: BoxFit.fitWidth,
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Gaiter Fall Prediction Report", style: header),
                    ],
                  ),
                  overflow: TextOverflow.span),
            )),
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Sampled on: ", style: detail),
                    TextSpan(text: patientData.date, style: detailBold),
                    TextSpan(text: " at ", style: detail),
                    TextSpan(text: patientData.time, style: detailBold),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Patient Name: ", style: detail),
                    TextSpan(
                        text:
                            "${patientData.firstname} ${patientData.lastname}",
                        style: detailBold),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Measurement Method: ", style: detail),
                    TextSpan(
                        text: patientData.isVideo ? "Video" : "Stopwatch",
                        style: detailBold),
                  ]),
                ),
              ]),
              Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Birth Date: ", style: detail),
                    TextSpan(text: patientData.bday, style: detailBold),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Age: ", style: detail),
                    TextSpan(text: patientData.age, style: detailBold),
                  ]),
                ),
              ]),
            ]),
            Spacer(),
            Row(children: [
              _gaitVelocityDetails(context),
              Spacer(),
              _fallRiskDetails(context, patientData.fallRisk),
            ]),
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
                            text: "© 2022 Gaiter Measurement Softwares")),
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

  Widget _gaitVelocityDetails(Context context) {
    return SizedBox(
      height: inch * 3,
      width: inch * 3,
      child: Container(
        decoration: BoxDecoration(
            color: PdfColors.white,
            border: Border(
                top: borderSide,
                bottom: borderSide,
                left: borderSide,
                right: borderSide),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Center(
          child: Column(
            children: [
              RichText(text: TextSpan(text: "Gait Velocity", style: header)),
              Spacer(),
              RichText(
                  text: TextSpan(text: patientData.velocity, style: subHeader)),
              Spacer(),
              RichText(text: TextSpan(text: "meters/second", style: detail)),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallRiskDetails(Context context, double risk) {
    final double riskPosition =
        (0.25 * inch + (inch * 2.5 * risk)).clamp(inch * 0.25, inch * 2.5);
    final String riskLevel = risk < 0.33
        ? "Low"
        : risk < 0.66
            ? "Moderate"
            : "High";

    return SizedBox(
      height: inch * 3,
      width: inch * 3,
      child: Container(
        decoration: BoxDecoration(
            color: PdfColors.white,
            border: Border(
                top: borderSide,
                bottom: borderSide,
                left: borderSide,
                right: borderSide),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Center(
          child: Column(
            children: [
              RichText(text: TextSpan(text: "Fall Risk", style: header)),
              Spacer(),
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: inch * 0.5,
                    width: inch * 2.5,
                  ),
                  SizedBox(
                      height: inch * 0.25,
                      width: inch * 2.5,
                      child: Rectangle(
                          fillColor: primaryColor,
                          strokeColor: secondaryColor)),
                  Positioned(
                    left: riskPosition,
                    child: SizedBox(
                        height: inch * 0.5,
                        width: inch * 0.5,
                        child: Circle(
                            fillColor: secondaryColor, strokeColor: black)),
                  )
                ],
              ),
              Spacer(),
              RichText(text: TextSpan(text: riskLevel, style: header)),
            ],
          ),
        ),
      ),
    );
  }
}

// final file =
//     File(userData["Last Name"] + userData["FirstName"] + userData["Age"]);
// await file.writeAsBytes(await pdf.save());
