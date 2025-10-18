import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/features/history/data/repositories/history_repository_impl.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';
import 'package:qrx_pro/features/scanner/domain/entities/qr_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.qrData});

  final String qrData;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late QrData _parsedData;
  // Get an instance of the repository from our DI container
  final IHistoryRepository _historyRepository = getIt<IHistoryRepository>();

  @override
  void initState() {
    super.initState();
    _parsedData = QrData(rawValue: widget.qrData);
  }

  Future<void> _openUrl() async {
    if (_parsedData.type != QrDataType.url) return;
    final uri = Uri.parse(_parsedData.rawValue);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackbar('Could not open the link.');
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _parsedData.rawValue));
    _showSnackbar('Copied to clipboard!');
  }

  void _shareData() {
    Share.share(_parsedData.rawValue);
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _saveToHistory() async {
    final historyItem = HistoryItem(
      rawValue: _parsedData.rawValue,
      timestamp: DateTime.now(),
      type: _parsedData.type.name, // Use the enum's name as a string
    );
    await _historyRepository.saveHistoryItem(historyItem);
    _showSnackbar('Saved to history!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDataCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    IconData icon;
    String title;
    Widget content;

    switch (_parsedData.type) {
      case QrDataType.url:
        icon = LucideIcons.link;
        title = 'Website URL';
        content = _buildContentText(_parsedData.rawValue);
        break;
      case QrDataType.wifi:
        icon = LucideIcons.wifi;
        title = 'WiFi Network';
        final wifiData = _parsedData.parsedData as WifiData;
        content = _buildWifiDetails(wifiData);
        break;
      case QrDataType.vcard:
        icon = LucideIcons.contact;
        title = 'Contact Card';
        content = _buildContentText(
          'vCard data detected. Full support coming soon.',
        );
        break;
      case QrDataType.text:
      default:
        icon = LucideIcons.fileText;
        title = 'Plain Text';
        content = _buildContentText(_parsedData.rawValue);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  // NEW helper widget for simple text display
  Widget _buildContentText(String text) {
    return SelectableText(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  // NEW helper widget to display formatted WiFi details
  Widget _buildWifiDetails(WifiData data) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(LucideIcons.signal),
          title: const Text('SSID'),
          subtitle: Text(data.ssid),
        ),
        ListTile(
          leading: const Icon(LucideIcons.lock),
          title: const Text('Password'),
          subtitle: Text(data.password.isEmpty ? 'No Password' : data.password),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        // conditional button
        if (_parsedData.type == QrDataType.wifi)
          FilledButton.icon(
            onPressed: () {
              // Future: Implement one-tap WiFi connection
              _showSnackbar('Auto-connect coming soon!');
            },
            icon: const Icon(LucideIcons.wifi),
            label: const Text('Connect'),
          ),

        if (_parsedData.type == QrDataType.url)
          FilledButton.tonalIcon(
            onPressed: _openUrl,
            icon: const Icon(LucideIcons.globe),
            label: const Text('Open Link'),
          ),
        FilledButton.tonalIcon(
          onPressed: _copyToClipboard,
          icon: const Icon(LucideIcons.copy),
          label: const Text('Copy'),
        ),
        FilledButton.tonalIcon(
          onPressed: _shareData,
          icon: const Icon(LucideIcons.share2),
          label: const Text('Share'),
        ),

        FilledButton.tonalIcon(
          onPressed: _saveToHistory,
          icon: const Icon(LucideIcons.history),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
