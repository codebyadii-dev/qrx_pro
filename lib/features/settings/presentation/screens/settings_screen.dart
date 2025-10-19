import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/core/config/app_theme_mode.dart';
import 'package:qrx_pro/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The SettingsCubit is provided higher up in the tree (in App widget)
    final settingsCubit = context.watch<SettingsCubit>();
    final state = settingsCubit.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
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
          ListTile(
            leading: const Icon(LucideIcons.trash2),
            title: const Text('Clear Scan History'),
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
