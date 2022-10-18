import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gaiter/patient_pdf.dart';
import 'package:meta/meta.dart';
import 'package:pdf/pdf.dart';

part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfLoading());
  bool viewCreated = false;

//TODO get the cubit out of the loading state
  void initPDFView() async {
    try {
      await generatePdf().then((pdfData) {
        PDFView view = PDFView(
          enableSwipe: false,
          pdfData: pdfData,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            emit(PdfError(exception: error));
          },
        );
        emit(PdfLoaded(pdfView: view));
      });
    } on Exception catch (error) {
      emit(PdfError(exception: error));
    }
  }
}
