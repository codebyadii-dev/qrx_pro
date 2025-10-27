import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/core/services/device/device_info_service.dart';
import 'package:qrx_pro/features/batch/presentation/widgets/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class BatchGeneratorScreen extends StatefulWidget {
  const BatchGeneratorScreen({super.key});

  @override
  State<BatchGeneratorScreen> createState() => _BatchGeneratorScreenState();
}

class _BatchGeneratorScreenState extends State<BatchGeneratorScreen> {
  // --- THIS IS THE FIX: The _selectedCsvFile variable has been removed ---
  String _feedbackMessage = 'No file selected. Please select a CSV file.';
  List<List<dynamic>> _csvData = [];

  Future<void> _showSuccessDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              repeat: false,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Success!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your ZIP file has been saved.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateBatch() async {
    if (_csvData.isEmpty) {
      _showSnackbar('No data to process.', isError: true);
      return;
    }

    final deviceInfoService = getIt<DeviceInfoService>();
    bool permissionGranted = true;
    if (Platform.isAndroid) {
      final sdkInt = await deviceInfoService.getAndroidSdkInt();
      if (sdkInt < 33) {
        final status = await Permission.storage.request();
        permissionGranted = status.isGranted;
      }
    }
    if (!mounted) return;
    if (!permissionGranted) {
      _showSnackbar('Storage permission is required.', isError: true);
      return;
    }

    final progressNotifier = ValueNotifier<int>(0);
    final buildContext = context;

    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (_) => ProgressDialog(
        progressNotifier: progressNotifier,
        totalItems: _csvData.length,
      ),
    );

    String? savedFilePath;

    try {
      final archive = Archive();
      for (int i = 0; i < _csvData.length; i++) {
        final rowData = _csvData[i][0].toString();
        final fileName = 'qr_code_$i.png';

        final painter = QrPainter(
          data: rowData,
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.M,
          gapless: false,
          color: Colors.black,
          emptyColor: Colors.white,
        );

        final picData = await painter.toImageData(250);
        if (picData != null) {
          final bytes = picData.buffer.asUint8List();
          archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
        }
        progressNotifier.value = i + 1;
        await Future.delayed(Duration.zero);
      }

      final zipData = ZipEncoder().encode(archive);

      final params = SaveFileDialogParams(
        data: Uint8List.fromList(zipData),
        fileName: 'qrx_pro_batch_${DateTime.now().millisecondsSinceEpoch}.zip',
      );

      savedFilePath = await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('An error occurred: $e', isError: true);
    } finally {
      if (mounted) Navigator.of(buildContext).pop();
      if (savedFilePath != null) {
        await _showSuccessDialog();
      }
    }
  }

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
          // We no longer set _selectedCsvFile here
          _csvData = fields;
          _feedbackMessage =
              '${fields.length} records found in ${result.files.single.name}';
        });
      } catch (e) {
        _showSnackbar('Error reading CSV file: $e', isError: true);
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
                        // The UI now depends only on whether _csvData is empty
                        _csvData.isEmpty
                            ? LucideIcons.fileUp
                            : LucideIcons.fileCheck2,
                        size: 50,
                        color: _csvData.isEmpty
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
              // The button's state also depends only on _csvData
              onPressed: _csvData.isEmpty ? null : _generateBatch,
              icon: const Icon(LucideIcons.scanLine),
              label: const Text('Generate QR Codes'),
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
