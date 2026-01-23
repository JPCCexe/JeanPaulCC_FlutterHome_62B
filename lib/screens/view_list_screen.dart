import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/model/watchlist_item.dart';

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} removed from watchlist'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
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
              leading: const Icon(Icons.movie),
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
