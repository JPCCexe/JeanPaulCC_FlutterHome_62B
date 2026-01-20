import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha(220),
                  Theme.of(context).colorScheme.primary.withAlpha(150),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.movie,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 18),
                Text(
                  'Watchlist',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              onSelectScreen('home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Movie/Series'),
            onTap: () {
              onSelectScreen('add');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('View Watchlist'),
            onTap: () {
              onSelectScreen('view');
            },
          ),
        ],
      ),
    );
  }
}
