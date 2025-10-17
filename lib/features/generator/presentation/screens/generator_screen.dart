import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrx_pro/features/generator/domain/entities/qr_style_data.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final _textController = TextEditingController();
  //  state variables for styling
  Color _foregroundColor = Colors.black;
  Color _backgroundColor = Colors.white;
  QrEyeShape _eyeShape = QrEyeShape.square;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Helper function to show the color picker dialog
  void _pickColor(Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _foregroundColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Done'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
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
          _buildStylingOptions(), // Add the new section
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
              // ***  LOGIC ***
              final text = _textController.text.trim();
              if (text.isNotEmpty) {
                context.push(
                  '/generator/preview',
                  extra: {
                    'data': text,
                    'style': QrStyleData(
                      foregroundColor: _foregroundColor,
                      backgroundColor: _backgroundColor,
                      eyeShape: _eyeShape,
                    ),
                  },
                );
              } else {
                // Show a snackbar if the input is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter some text or a URL.'),
                    duration: Duration(seconds: 2),
                  ),
                );
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

  //  WIDGET for styling options
  Widget _buildStylingOptions() {
    return Card(
      child: ExpansionTile(
        leading: const Icon(LucideIcons.palette),
        title: const Text('Styling Options'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                _buildColorPickerTile('Foreground', _foregroundColor, (color) {
                  setState(() => _foregroundColor = color);
                }),
                _buildColorPickerTile('Background', _backgroundColor, (color) {
                  setState(() => _backgroundColor = color);
                }),
                _buildEyeShapeSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  HELPER for color picker tiles
  Widget _buildColorPickerTile(
    String title,
    Color color,
    Function(Color) onColorChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: CircleAvatar(backgroundColor: color, radius: 14),
      onTap: () => _pickColor(onColorChanged),
    );
  }

  //  WIDGET for eye shape selection
  Widget _buildEyeShapeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Eye Shape'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ChoiceChip(
              label: const Text('Square'),
              selected: _eyeShape == QrEyeShape.square,
              onSelected: (selected) {
                if (selected) setState(() => _eyeShape = QrEyeShape.square);
              },
            ),
            ChoiceChip(
              label: const Text('Circle'),
              selected: _eyeShape == QrEyeShape.circle,
              onSelected: (selected) {
                if (selected) setState(() => _eyeShape = QrEyeShape.circle);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    // This is a placeholder for now. We will expand this in future .
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
