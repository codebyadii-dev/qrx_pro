import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BatchGeneratorScreen extends StatefulWidget {
  const BatchGeneratorScreen({super.key});

  @override
  State<BatchGeneratorScreen> createState() => _BatchGeneratorScreenState();
}

class _BatchGeneratorScreenState extends State<BatchGeneratorScreen> {
  File? _selectedCsvFile;
  String _feedbackMessage = 'No file selected. Please select a CSV file.';
  List<List<dynamic>> _csvData = [];
  bool _isProcessing = false;

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  Future<void> _pickCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      try {
        final input = file.openRead();
        final fields = await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter())
            .toList();

        setState(() {
          _selectedCsvFile = file;
          _csvData = fields;
          _feedbackMessage =
              '${fields.length} records found in ${result.files.single.name}';
        });
      } catch (e) {
        _showSnackbar('Error reading CSV file: $e', isError: true);
      }
    }
  }

  Future<void> _generateBatch() async {
    if (_csvData.isEmpty) {
      _showSnackbar('No data to process.', isError: true);
      return;
    }

    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showSnackbar(
          'Storage permission is required to save the file.',
          isError: true,
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final archive = Archive();

      for (int i = 0; i < _csvData.length; i++) {
        final rowData = _csvData[i][0].toString();
        final fileName = 'qr_code_$i.png';

        final painter = QrPainter(
          data: rowData,
          version: QrVersions.auto,
          gapless: false,
        );

        final picData = await painter.toImageData(250);
        if (picData != null) {
          final bytes = picData.buffer.asUint8List();
          archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
        }
      }

      final zipData = ZipEncoder().encode(archive); // This is now non-nullable

      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Could not find downloads directory.');
      }

      final savePath =
          '${downloadsDir.path}/qrx_pro_batch_${DateTime.now().millisecondsSinceEpoch}.zip';
      final savedFile = File(savePath);
      await savedFile.writeAsBytes(zipData);

      _showSnackbar('Successfully saved to $savePath');
    } catch (e) {
      _showSnackbar('An error occurred: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Batch QR Generator')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: InkWell(
                onTap: _pickCsvFile,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        _selectedCsvFile == null
                            ? LucideIcons.fileUp
                            : LucideIcons.fileCheck2,
                        size: 50,
                        color: _selectedCsvFile == null
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select CSV File',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _feedbackMessage,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: _csvData.isEmpty
                    ? const Center(
                        child: Text('Data preview will appear here...'),
                      )
                    : ListView.builder(
                        itemCount: _csvData.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text('${index + 1}.'),
                            title: Text(_csvData[index][0].toString()),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _selectedCsvFile == null || _isProcessing
                  ? null
                  : _generateBatch,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.scanLine),
              label: Text(
                _isProcessing ? 'Processing...' : 'Generate QR Codes',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
