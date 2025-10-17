import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.data});

  final String data;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  // State variables to hold the live style
  Color _foregroundColor = Colors.black;
  Color _backgroundColor = Colors.white;
  QrEyeShape _eyeShape = QrEyeShape.square;
  File? _logoImage;

  // Method to pick an image from the gallery
  Future<void> _pickLogoImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _logoImage = File(pickedFile.path);
      });
    }
  }

  void _pickColor(bool isForeground) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isForeground ? 'Pick Foreground Color' : 'Pick Background Color',
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: isForeground ? _foregroundColor : _backgroundColor,
            onColorChanged: (color) {
              setState(() {
                if (isForeground) {
                  _foregroundColor = color;
                } else {
                  _backgroundColor = color;
                }
              });
            },
          ),
        ),
        actions: [
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
      appBar: AppBar(title: const Text('Preview')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // The QR Code View
          Card(
            elevation: 2,
            color: _backgroundColor, // Live background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: QrImageView(
                data: widget.data,
                version: QrVersions.auto,
                size: 250.0,
                // Apply live styles
                eyeStyle: QrEyeStyle(
                  eyeShape: _eyeShape,
                  color: _foregroundColor,
                ),
                dataModuleStyle: QrDataModuleStyle(color: _foregroundColor),
                // ***  LOGO LOGIC***
                embeddedImage: _logoImage != null
                    ? FileImage(_logoImage!)
                    : null,
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(50, 50),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Styling Options Moved Here
          _buildStylingOptions(),
          const SizedBox(height: 24),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  /* Phase 19 */
                },
                icon: const Icon(LucideIcons.download),
                label: const Text('Save'),
              ),
              const SizedBox(width: 16),
              FilledButton.tonalIcon(
                onPressed: () {
                  /* Phase 19 */
                },
                icon: const Icon(LucideIcons.share2),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStylingOptions() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true, // Start with options visible
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Foreground'),
                  trailing: CircleAvatar(
                    backgroundColor: _foregroundColor,
                    radius: 14,
                  ),
                  onTap: () => _pickColor(true),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Background'),
                  trailing: CircleAvatar(
                    backgroundColor: _backgroundColor,
                    radius: 14,
                  ),
                  onTap: () => _pickColor(false),
                ),
                const Divider(),
                const Text('Eye Shape'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: const Text('Square'),
                      selected: _eyeShape == QrEyeShape.square,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _eyeShape = QrEyeShape.square);
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Circle'),
                      selected: _eyeShape == QrEyeShape.circle,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _eyeShape = QrEyeShape.circle);
                        }
                      },
                    ),
                  ],
                ),

                const Divider(),
                // ***  THE LOGO PICKER TILE ***
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(LucideIcons.imagePlus),
                  title: const Text('Add Logo'),
                  subtitle: Text(
                    _logoImage == null ? 'No image selected' : 'Change image',
                  ),
                  trailing: _logoImage != null
                      ? IconButton(
                          icon: const Icon(
                            LucideIcons.xCircle,
                            color: Colors.red,
                          ),
                          onPressed: () => setState(() => _logoImage = null),
                        )
                      : null,
                  onTap: _pickLogoImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
