import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaitr/components/consent_dialog.dart';
import 'package:gaitr/cubit/pdf/pdf_cubit.dart';
import 'package:gaitr/components/fancy_plasma.dart';
import 'package:gaitr/data_helper.dart';
import 'package:gaitr/models/patient_data.dart';
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
    return CupertinoPageScaffold(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          FancyPlasmaWidget(color: CupertinoColors.systemBlue.withOpacity(0.4)),
          BlocProvider(
            create: (context) => PdfCubit()..initPDFView(),
            child: BlocBuilder<PdfCubit, PdfState>(
              builder: (context, state) {
                if (state is PdfLoaded) {
                  return SafeArea(
                    child: Center(
                      child: Column(children: [
                        Text(
                          "${patientData.firstname} ${patientData.lastname} Gait Report",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 8.5 / 11,
                            child: state.pdfView,
                          ),
                        ),
                        const Text(
                            "Pinch the PDF to preview the full document"),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            CupertinoButton(
                              color: CupertinoColors.link,
                              onPressed: () {
                                consentDialog(
                                    context,
                                    "Clear patient gait data",
                                    "Are you sure you want to redo the gait analysis",
                                    "No",
                                    "Yes",
                                    () => Navigator.pop(context),
                                    () => Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/measurement',
                                        ModalRoute.withName('/'),
                                        arguments: patientData.isVideo));
                              },
                              child: const Text("Redo"),
                            ),
                            const Spacer(),
                            CupertinoButton(
                              color: CupertinoColors.link,
                              onPressed: () {
                                consentDialog(
                                    context,
                                    "Save patient gait data",
                                    "Are you sure you want to proceed",
                                    "No",
                                    "Yes",
                                    () => Navigator.pop(context), () {
                                  try {
                                    prepareEmail(context, state);
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                });
                              },
                              child: const Text("Save"),
                            )
                          ]),
                        )
                      ]),
                    ),
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

//TODO check if online before doing this
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
