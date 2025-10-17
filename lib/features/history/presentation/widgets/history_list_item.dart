import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrx_pro/features/history/domain/entities/history_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryListItem extends StatelessWidget {
  const HistoryListItem({super.key, required this.item});

  final HistoryItem item;

  @override
  Widget build(BuildContext context) {
    // A simple way to map the type string back to an icon
    final IconData iconData = item.type == 'url'
        ? LucideIcons.link
        : LucideIcons.fileText;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(iconData, color: Theme.of(context).colorScheme.primary),
        title: Text(
          item.rawValue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          timeago.format(item.timestamp), // e.g., "5 minutes ago"
        ),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: () {
          // Future: Navigate to a detailed view of the history item
        },
      ),
    );
  }
}
