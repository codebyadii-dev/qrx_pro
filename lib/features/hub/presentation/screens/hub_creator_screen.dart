import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/features/hub/data/repositories/hub_repository_impl.dart';

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
  final IHubRepository _hubRepository = getIt<IHubRepository>();
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _headerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createAndPreview() async {
    // Basic validation
    if (_titleController.text.isEmpty || _linkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Primary Link are required.')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final newHubPage = await _hubRepository.saveHubPage(
        title: _titleController.text,
        description: _descriptionController.text,
        primaryLink: _linkController.text,
        imageFile: _headerImage,
      );

      // In the next , we'll navigate to the preview screen.
      // For now, just show a success message.
      if (!mounted) return;
      context.push('/generator/hub/preview', extra: newHubPage);
      // Optional: Pop the creator screen so back button on preview goes to main generator
      // context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hub Page created with ID: ${newHubPage.id}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating page: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
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
            onPressed: _isProcessing ? null : _createAndPreview,
            icon: _isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(LucideIcons.eye),
            label: Text(_isProcessing ? 'Creating...' : 'Create & Preview'),
            // ... (style)
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
