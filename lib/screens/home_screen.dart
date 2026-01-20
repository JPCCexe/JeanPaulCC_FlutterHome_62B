import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/screens/add_item_screen.dart';
import 'package:watchlist_manager_movies_series/screens/view_list_screen.dart';
import 'package:watchlist_manager_movies_series/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _selectScreen(BuildContext context, String identifier) {
    Navigator.of(context).pop(); // Close drawer

    if (identifier == 'add') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const AddItemScreen()));
    } else if (identifier == 'view') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => const ViewListScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie & Series Watchlist')),
      drawer: MainDrawer(
        onSelectScreen: (identifier) => _selectScreen(context, identifier),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text('Welcome to Your Watchlist', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
