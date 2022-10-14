import 'package:flutter/material.dart';

import 'package:gaiter/storageHelper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PatientPDF extends StatelessWidget {
  const PatientPDF({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document(
        title: userData["Last Name"] + userData["First Name"] + userData["Age"],
        creator: "Gaiter Systems");
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(8.5, 11.0, marginAll: 1.0),
        build: (pw.Context context) => pw.Center(
            child: pw.Column(children: [
          pw.Text(userData["Now"]),
          pw.Text(userData["First Name"]),
          pw.Text(userData["Last Name"]),
          pw.Text(userData["Birth Date"]),
          pw.Text(userData["Age"]),
          pw.Text(userData["Birth Date"]),
          pw.Text(userData["Gait Velocity"]),
        ])),
      ),
    );

    return FutureBuilder<Widget>(
        future: pdf.document.save().then((bytes) => Image.memory(bytes)),
        initialData: const CircularProgressIndicator(),
        builder: ((context, snapshot) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 2,
            child: AspectRatio(
                aspectRatio: 8.5 / 11,
                child: Center(
                  child: snapshot.data!,
                )),
          );
        }));
  }
}

  // final file =
  //     File(userData["Last Name"] + userData["FirstName"] + userData["Age"]);
  // await file.writeAsBytes(await pdf.save());