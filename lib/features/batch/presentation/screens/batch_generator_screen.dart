import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BatchGeneratorScreen extends StatefulWidget {
  const BatchGeneratorScreen({super.key});

  @override
  State<BatchGeneratorScreen> createState() => _BatchGeneratorScreenState();
}

class _BatchGeneratorScreenState extends State<BatchGeneratorScreen> {
  File? _selectedCsvFile;
  String _feedbackMessage = 'No file selected. Please select a CSV file.';

  Future<void> _pickCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedCsvFile = File(result.files.single.path!);
        _feedbackMessage = 'File: ${result.files.single.name}';
        // In the next phase, we will parse and preview the data here.
      });
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
            // File selection card
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
            // Data preview section (placeholder for now)
            const Expanded(
              child: Card(
                child: Center(child: Text('Data preview will appear here...')),
              ),
            ),
            const SizedBox(height: 16),
            // Generate button
            FilledButton.icon(
              onPressed: _selectedCsvFile == null
                  ? null
                  : () {
                      // Logic for Phase 25
                    },
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
