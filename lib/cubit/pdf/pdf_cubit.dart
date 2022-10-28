import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gaiter/patient_pdf.dart';
import 'package:gaiter/storageHelper.dart';
import 'package:meta/meta.dart';

part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfLoading());
  bool viewCreated = false;

  //TODO display the PDF in an unzoomed state
  void initPDFView() async {
    emit(PdfLoading());
    try {
      PatientPdf patientPdf = PatientPdf();
      await patientPdf
          .configPdfStyles()
          .then((_) => PatientPdf().generatePdf(userData))
          .then((pdfData) {
        PDFView view = PDFView(
            enableSwipe: false,
            pdfData: pdfData,
            autoSpacing: false,
            pageFling: false,
            onError: (error) => emit(PdfError(exception: error)),
            onPageError: (page, error) => emit(PdfError(exception: error)),
            pageSnap: false);
        emit(PdfLoaded(pdfView: view));
      });
    } on Exception catch (error) {
      emit(PdfError(exception: error));
    } catch (e) {
      log(e.toString());
    }
  }
}
