import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create QR Code')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTextField(),
          const SizedBox(height: 24),
          _buildActionButtons(),
          const SizedBox(height: 24),
          _buildTypeSelector(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: _textController,
          maxLines: 5,
          minLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter text or URL here...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              // Logic for Phase 15
              final text = _textController.text;
              if (text.isNotEmpty) {
                // Future: Navigate to preview screen
              }
            },
            icon: const Icon(LucideIcons.eye),
            label: const Text('Preview'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {
              _textController.clear();
            },
            icon: const Icon(LucideIcons.x),
            label: const Text('Clear'),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    // This is a placeholder for now. We will expand this in future phases.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose QR Type', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        // Placeholder for a grid of QR type options (WiFi, Contact, etc.)
        const Card(
          child: ListTile(
            leading: Icon(LucideIcons.text),
            title: Text('More Types'),
            subtitle: Text('WiFi, Contact, Calendar and more...'),
            trailing: Icon(LucideIcons.chevronRight),
          ),
        ),
      ],
    );
  }
}
