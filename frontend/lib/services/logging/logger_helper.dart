import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../constants/sizes.dart';
import 'logger_service.dart';

Future<File?> generateLogPdf(List<String> lines) async {
  try {
    final pdf = pw.Document();
    // Load custom font
    final robotoRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final robotoBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    if (lines.isEmpty) {
      LoggerService.logger?.e('Error: The log lines list is empty!');
      return null;
    }
    List<String> logEntries = lines.map((e) => splitLogs(e)).reduce((value, element) => value + element).reversed.toList();
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(Paddings.regular),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => logEntries.map((line) => formatLogLine(line, robotoRegular, robotoBold)).toList(),
      ),
    );

    // Save PDF to a temporary file
    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/filtered_log.pdf');
    final bytes = await pdf.save();
    await pdfFile.writeAsBytes(bytes);
    return pdfFile;
  } catch (e) {
    LoggerService.logger?.e('Error generating PDF: $e');
    return null;
  }
}

List<String> splitLogs(String rawLogs) {
  // Split logs based on timestamp (ensuring each entry starts with a timestamp)
  final logPattern = RegExp(r'(?=\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[.*?\])');
  return rawLogs.split(logPattern).where((entry) => entry.trim().isNotEmpty).toList();
}

pw.Widget formatLogLine(String line, pw.Font regularFont, pw.Font boldFont) {
  final regex = RegExp(r'^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) (\[.*?\]) (.*)');
  final match = regex.firstMatch(line);

  if (match != null) {
    final timestamp = match.group(1) ?? '';
    final level = match.group(2) ?? '';
    final message = match.group(3) ?? '';

    PdfColor levelColor = PdfColors.black;
    if (level.contains('ERROR')) levelColor = PdfColors.red;
    if (level.contains('WARNING')) levelColor = PdfColors.orange;
    if (level.contains('INFO')) levelColor = PdfColors.blue;

    return pw.Wrap(
      children: [
        pw.Text('$timestamp ', style: pw.TextStyle(font: regularFont, color: PdfColors.grey)),
        pw.Text('$level ', style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold, color: levelColor)),
        ...message.split(' ').map((e) => pw.Text(' $e', style: pw.TextStyle(font: regularFont, color: PdfColors.black))),
      ],
    );
  }

  return pw.Text(line, style: pw.TextStyle(font: regularFont, color: PdfColors.black), softWrap: true);
}
