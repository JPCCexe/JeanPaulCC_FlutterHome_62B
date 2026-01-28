import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/model/watchlist_item.dart';
import 'dart:io';

// Import for Fire base analytics
import 'package:firebase_analytics/firebase_analytics.dart';

// Stateless widget displaying the watchlist with swipe to delete functionality
class ViewListScreen extends StatelessWidget {
  const ViewListScreen({
    super.key,
    required this.items,
    required this.onRemoveItem,
  });

  final List<WatchlistItem> items;
  final void Function(String id) onRemoveItem;

  void _removeItem(BuildContext context, WatchlistItem item) {
    onRemoveItem(item.id);

    // Log for removing item
    FirebaseAnalytics.instance.logEvent(
      name: 'remove_item',
      parameters: {'item_title': item.title, 'item_genre': item.genre.name},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} removed from watchlist'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Log view watchlist event
    FirebaseAnalytics.instance.logEvent(
      name: 'view_watchlist',
      parameters: {'item_count': items.length},
    );

    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add a Movie/Serie',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Try adding some movies!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );

    if (items.isNotEmpty) {
      content = ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];

          return Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            onDismissed: (direction) {
              _removeItem(context, item);
            },
            child: ListTile(
              leading: item.imagePath != null
                  ? Image.file(
                      File(item.imagePath!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.movie),
              title: Text(item.title),
              subtitle: Text('${item.genre.name} - ${item.status.name}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text('${item.rating}'),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('View Watchlist')),
      body: content,
    );
  }
}
