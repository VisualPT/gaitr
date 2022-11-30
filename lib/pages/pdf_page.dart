import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaitr/app_styles.dart';
import 'package:gaitr/components/consent_dialog.dart';
import 'package:gaitr/cubit/pdf/pdf_cubit.dart';
import 'package:gaitr/components/fancy_plasma.dart';
import 'package:gaitr/models/patient_data.dart';
import 'package:gaitr/pages/pages.dart';
import 'package:http/http.dart' as http;

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final double height = 60;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const FancyPlasmaWidget(),
          BlocProvider(
            create: (context) => PdfCubit()..initPDFView(),
            child: BlocBuilder<PdfCubit, PdfState>(
              builder: (context, state) {
                if (state is PdfLoaded) {
                  return SafeArea(
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                          height: screenSize.height - 30,
                          width: screenSize.width - 20),
                      Positioned(
                        top: 20,
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text("Generated PDF",
                                style: AppStyles.titleTextStyle)),
                      ),
                      SizedBox(
                        width: screenSize.width - 20,
                        child: AspectRatio(
                          aspectRatio: 8.5 / 11,
                          child: state.pdfView,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: SizedBox(
                          width: screenSize.width - 20,
                          child: Row(children: [
                            CupertinoButton(
                              padding: const EdgeInsets.all(13.0),
                              color: AppStyles.brandTertiaryOrange
                                  .withOpacity(0.8),
                              onPressed: () {
                                consentDialog(
                                    context,
                                    "Clear patient data",
                                    "Do you want to repeat the analysis?",
                                    "No",
                                    "Yes",
                                    () => Navigator.pop(context),
                                    () => Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/measurement',
                                        ModalRoute.withName('/'),
                                        arguments: patientData.isVideo));
                              },
                              child:
                                  const Icon(CupertinoIcons.restart, size: 35),
                            ),
                            const Spacer(),
                            SizedBox(
                              child: CupertinoButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: (screenSize.width / 4) - 50),
                                color: CupertinoColors.link,
                                onPressed: () {
                                  consentDialog(
                                      context,
                                      "Save patient gait data",
                                      "Email will be sent to: ${patientData.managingtherapistEmail}",
                                      "No",
                                      "Yes",
                                      () => Navigator.pop(context), () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const LoadingPage(
                                                  message: "Sending email",
                                                  isLoading: true)),
                                    );
                                    try {
                                      prepareEmail(context, state);
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  });
                                },
                                child: const Text("Save to email",
                                    style: AppStyles.buttonLabelStyle),
                              ),
                            )
                          ]),
                        ),
                      )
                    ]),
                  );
                } else if (state is PdfLoading) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (state is PdfError) {
                  return Center(
                    child: Text(state.exception.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("Invalid PDF State"),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void prepareEmail(BuildContext context, PdfLoaded state) {
    patientData.rawReportData =
        uint8ListTob64(state.pdfView.pdfData!).toString();

    sendEmail().then(
      (response) {
        log(response.body);
        if (response.body == 'OK') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            ModalRoute.withName('/'),
          );
        }
      },
    );
  }
}

Future<http.Response> sendEmail() async {
  const serviceId = "service_1j62fhe";
  const templateId = "template_95smzbm";
  const userId = "_SUuxjVW52hmODTRs";

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  try {
    return await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-type': 'application/json'
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'patient_name': "${patientData.firstname} ${patientData.lastname}",
            'patient_dob': patientData.bday,
            'user_email': patientData.managingtherapistEmail,
            'patient_pdf': patientData.rawReportData,
          }
        },
      ),
    );
  } catch (e) {
    return http.Response(e.toString(), 404);
  }
}

String uint8ListTob64(Uint8List uint8list) {
  String base64String = base64Encode(uint8list);
  String header = 'data:application/pdf;base64,';
  return header + base64String;
}
