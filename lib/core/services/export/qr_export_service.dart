import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

@lazySingleton
class QrExportService {
  /// Generates PDF data from a QrPainter object. This method is stable and reliable.
  Future<Uint8List> exportToPdf(QrPainter painter) async {
    final pdf = pw.Document();
    // Generate a high-resolution image for crisp quality in the PDF
    final qrImageData = await painter.toImageData(2048);
    if (qrImageData == null) {
      throw Exception('Could not generate QR image data.');
    }
    final image = pw.MemoryImage(qrImageData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            // Embed the high-resolution image in the center of the PDF page
            child: pw.Image(image, width: 200, height: 200),
          );
        },
      ),
    );
    return pdf.save();
  }
}
