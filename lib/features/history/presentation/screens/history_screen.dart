import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';
import 'package:qrx_pro/features/history/presentation/widgets/history_list_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  //  mock data
  final List<HistoryItem> _mockHistoryItems = const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {
              /* Future: Implement search */
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () {
              /* Future: Implement clear history */
            },
          ),
        ],
      ),
      body: _mockHistoryItems.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: _mockHistoryItems.length,
      itemBuilder: (context, index) {
        // THE FIX IS HERE: Changed '_mock_history_items' to '_mockHistoryItems'
        return HistoryListItem(item: _mockHistoryItems[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.archive, size: 70, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'No History Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your scanned and generated codes will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
