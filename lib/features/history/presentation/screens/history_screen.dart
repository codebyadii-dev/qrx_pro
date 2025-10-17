import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/common/cubit/base_state.dart';
import 'package:qrx_pro/core/di/service_locator.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';
import 'package:qrx_pro/features/history/presentation/cubit/history_cubit.dart';
import 'package:qrx_pro/features/history/presentation/widgets/history_list_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HistoryCubit>()..loadHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          actions: [
            IconButton(icon: const Icon(LucideIcons.search), onPressed: () {}),
            IconButton(icon: const Icon(LucideIcons.trash2), onPressed: () {}),
          ],
        ),
        body: BlocBuilder<HistoryCubit, BaseState<List<HistoryItem>>>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (items) =>
                  items.isEmpty ? _buildEmptyState() : _buildHistoryList(items),
              error: (message) => Center(child: Text('Error: $message')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<HistoryItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return HistoryListItem(item: items[index]);
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
            'Your saved items will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
