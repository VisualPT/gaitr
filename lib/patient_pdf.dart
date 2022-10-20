//DO NOT IMPORT material.dart without renaming it with <as> keyword, will conflict with pdf/widgets.dart
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'storageHelper.dart';

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

  late TextStyle header;
  late TextStyle headerItalic;
  late TextStyle detail;
  late TextStyle detailBold;
  late TextStyle subHeader;

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
    return;
  }

  Future<Uint8List> generatePdf(UserData userData) async {
    await configPdfStyles();
    final logo = await rootBundle.loadString('assets/fyzman-blue.svg');

    final pdf = Document(
        title: userData.lastname + userData.firstname + userData.age.toString(),
        creator: "Gaiter Systems");

    pdf.addPage(
      Page(
        build: (Context context) => Center(
          child: Column(children: [
            Header(
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "${userData.firstname} ${userData.lastname}",
                          style: headerItalic),
                      TextSpan(text: "'s Gait Report", style: header),
                    ],
                  ),
                  overflow: TextOverflow.span),
            ),
            Row(children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Birth Date: ", style: detail),
                  TextSpan(text: userData.bday, style: detailBold),
                ]),
              ),
              Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: "Sampled on ", style: detail),
                  TextSpan(text: userData.date, style: detailBold),
                  TextSpan(text: " at ", style: detail),
                  TextSpan(text: userData.time, style: detailBold),
                ]),
              ),
            ]),
            Spacer(),
            _gaitVelocityDetails(context),
            Spacer(),
            _fallRiskDetails(context, userData.fallRisk),
            Spacer(flex: 2),
            //Footer(),
          ]),
        ),
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.letter,
          buildBackground: (context) => FullPage(
            ignoreMargins: true,
            child: SvgImage(svg: logo, fit: BoxFit.fitHeight),
          ),
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
                  text: TextSpan(text: userData.velocity, style: subHeader)),
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
