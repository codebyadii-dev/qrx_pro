import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HubCreatorScreen extends StatefulWidget {
  const HubCreatorScreen({super.key});

  @override
  State<HubCreatorScreen> createState() => _HubCreatorScreenState();
}

class _HubCreatorScreenState extends State<HubCreatorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();
  File? _headerImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _headerImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Hub Page')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildImagePicker(),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _titleController,
            icon: LucideIcons.heading1,
            label: 'Title',
            hint: 'e.g., My Portfolio',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            icon: LucideIcons.text,
            label: 'Description',
            hint: 'A short bio or summary...',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _linkController,
            icon: LucideIcons.link,
            label: 'Primary Link URL',
            hint: 'https://example.com',
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              // Logic for Phase 28
            },
            icon: const Icon(LucideIcons.eye),
            label: const Text('Create & Preview'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: _headerImage != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_headerImage!),
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: _headerImage == null
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.imagePlus, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Add a header image (optional)'),
                  ],
                )
              : Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(LucideIcons.x, color: Colors.white, size: 18),
                    ),
                    onPressed: () => setState(() => _headerImage = null),
                  ),
                ),
        ),
      ),
    );
  }
}
