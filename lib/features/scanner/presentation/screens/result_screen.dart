import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/common/cubit/base_state.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/features/history/data/repositories/history_repository_impl.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';
import 'package:qrx_pro/features/scanner/domain/entities/qr_data.dart';
import 'package:qrx_pro/features/scanner/domain/entities/url_metadata.dart';
import 'package:qrx_pro/features/scanner/presentation/cubit/url_metadata_cubit.dart';
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
  // Get an instance of the cubit
  late final UrlMetadataCubit _metadataCubit;

  @override
  void initState() {
    super.initState();
    _parsedData = QrData(rawValue: widget.qrData);
    _metadataCubit = getIt<UrlMetadataCubit>();

    // If the scanned data is a URL, start fetching its metadata.
    if (_parsedData.type == QrDataType.url) {
      _metadataCubit.fetchMetadata(_parsedData.rawValue);
    }
  }

  @override
  void dispose() {
    _metadataCubit.close(); // Clean up the cubit
    super.dispose();
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
    return BlocProvider.value(
      value: _metadataCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan Result')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_parsedData.type == QrDataType.url) ...[
                _buildAiInsightCard(),
                const SizedBox(height: 16),
              ],
              _buildDataCard(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
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

  // NEW WIDGET to display AI insights
  Widget _buildAiInsightCard() {
    return BlocBuilder<UrlMetadataCubit, BaseState<UrlMetadata>>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Analyzing URL...'),
                ],
              ),
            ),
          ),
          error: (message) => Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Could not analyze URL: $message'),
            ),
          ),
          success: (metadata) {
            final scoreColor = metadata.safetyScore > 0.9
                ? Colors.green
                : metadata.safetyScore > 0.6
                ? Colors.orange
                : Colors.red;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: metadata.faviconUrl.isEmpty
                            ? const Icon(LucideIcons.globe)
                            : Image.network(
                                metadata.faviconUrl,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(LucideIcons.globe),
                              ),
                      ),
                      title: Text(
                        metadata.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        metadata.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      'Safety Score',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: metadata.safetyScore,
                            backgroundColor: scoreColor.withOpacity(0.2),
                            color: scoreColor,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(metadata.safetyScore * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
