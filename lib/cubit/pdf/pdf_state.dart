part of 'pdf_cubit.dart';

@immutable
abstract class PdfState {}

class PdfLoading extends PdfState {}

class PdfLoaded extends PdfState {
  final PDFView pdfView;
  PdfLoaded({required this.pdfView});
}

class PdfError extends PdfState {
  final Exception exception;
  PdfError({required this.exception});
}
