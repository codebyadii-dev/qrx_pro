import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  void _onPreview() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.push('/generator/preview', extra: text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text or a URL.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create QR Code')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Text input card
          Card(
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
          ),
          const SizedBox(height: 24),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _onPreview,
                  icon: const Icon(LucideIcons.eye),
                  label: const Text('Preview'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _textController.clear(),
                  icon: const Icon(LucideIcons.x),
                  label: const Text('Clear'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Card(
            child: ListTile(
              onTap: () =>
                  context.push('/generator/batch'), // Navigate to batch screen
              leading: const Icon(LucideIcons.binary),
              title: const Text('Batch Generate from CSV'),
              subtitle: const Text('Create multiple QR codes at once'),
              trailing: const Icon(LucideIcons.chevronRight),
            ),
          ),
          const SizedBox(height: 16),
          // --- Hub CARD ---
          Card(
            child: ListTile(
              onTap: () => context.push('/generator/hub'),
              leading: const Icon(LucideIcons.layoutTemplate),
              title: const Text('Create a Hub Page'),
              subtitle: const Text('A mini-page for your links'),
              trailing: const Icon(LucideIcons.chevronRight),
            ),
          ),
        ],
      ),
    );
  }
}
