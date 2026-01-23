import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/model/watchlist_item.dart';
import 'package:watchlist_manager_movies_series/screens/add_item_screen.dart';
import 'package:watchlist_manager_movies_series/screens/view_list_screen.dart';
import 'package:watchlist_manager_movies_series/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<WatchlistItem> _items = [];

  // Loading items when app starts
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Loading saved items from Local Storage
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString('watchlist_items');

    if (itemsJson != null) {
      final List<dynamic> decoded = json.decode(itemsJson);
      setState(() {
        _items.clear();
        for (var item in decoded) {
          _items.add(
            WatchlistItem(
              id: item['id'],
              title: item['title'],
              genre: Genre.values.firstWhere((e) => e.name == item['genre']),
              status: WatchStatus.values.firstWhere(
                (e) => e.name == item['status'],
              ),
              rating: item['rating'],
            ),
          );
        }
      });
    }
  }

  // ADDED: Save items to storage
  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsJson = _items.map((item) {
      return {
        'id': item.id,
        'title': item.title,
        'genre': item.genre.name,
        'status': item.status.name,
        'rating': item.rating,
      };
    }).toList();

    final String encoded = json.encode(itemsJson);
    await prefs.setString('watchlist_items', encoded);
  }

  void _addItem(WatchlistItem item) {
    setState(() {
      _items.add(item);
    });
    _saveItems();
  }

  void _selectScreen(BuildContext context, String identifier) {
    Navigator.of(context).pop();

    if (identifier == 'add') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => AddItemScreen(onAddItem: _addItem)),
      );
    } else if (identifier == 'view') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => ViewListScreen(items: _items)),
      );
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
