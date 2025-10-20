import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/core/config/app_theme_mode.dart';
import 'package:qrx_pro/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // New mock function to simulate the backup process
  Future<void> _mockBackupFlow(BuildContext context) async {
    // Show initial feedback
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Starting backup process...')));

    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Guard against async gap
    if (!context.mounted) return;

    // Show final "coming soon" message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'Backing up your data to the cloud is a premium feature that is coming soon!',
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

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.watch<SettingsCubit>();
    final state = settingsCubit.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          // ... (Theme ListTile)
          ListTile(
            leading: const Icon(LucideIcons.paintbrush),
            title: const Text('Theme'),
            trailing: DropdownButton<AppThemeMode>(
              value: state.themeMode,
              items: AppThemeMode.values
                  .map(
                    (theme) => DropdownMenuItem(
                      value: theme,
                      child: Text(
                        theme.name[0].toUpperCase() + theme.name.substring(1),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (theme) {
                if (theme != null) {
                  settingsCubit.changeTheme(theme);
                }
              },
            ),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Privacy'),
          // ... (Offline Mode SwitchListTile)
          SwitchListTile(
            secondary: const Icon(LucideIcons.shield),
            title: const Text('Offline Secure Mode'),
            subtitle: const Text('Disable all network calls'),
            value: state.isOfflineMode,
            onChanged: (isEnabled) =>
                settingsCubit.toggleOfflineMode(isEnabled),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Data'),
          // --- ADD THIS NEW LISTTILE FOR BACKUP ---
          ListTile(
            leading: const Icon(LucideIcons.uploadCloud),
            title: const Text('Backup to Cloud'),
            subtitle: const Text('Save your history & settings'),
            onTap: () => _mockBackupFlow(context),
          ),
          ListTile(
            leading: const Icon(LucideIcons.trash2, color: Colors.red),
            title: const Text(
              'Clear Scan History',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final confirmed = await _showConfirmationDialog(context);
              if (confirmed ?? false) {
                await settingsCubit.clearHistory();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('History cleared successfully!'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text(
          'Are you sure you want to delete all scan history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
