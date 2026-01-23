import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/model/watchlist_item.dart';
import 'package:watchlist_manager_movies_series/services/notification_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.onAddItem});

  final void Function(WatchlistItem) onAddItem;

  @override
  State<AddItemScreen> createState() {
    return _AddItemScreenState();
  }
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _titleController = TextEditingController();
  var _selectedGenre = Genre.action;
  var _selectedStatus = WatchStatus.wantToWatch;
  var _selectedRating = 3;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter a title.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    final newItem = WatchlistItem(
      id: DateTime.now().toString(),
      title: _titleController.text,
      genre: _selectedGenre,
      status: _selectedStatus,
      rating: _selectedRating,
    );

    widget.onAddItem(newItem);

    await NotificationService.showNotification(
      'New ${_selectedGenre.name.toUpperCase()} Added!',
      '${_titleController.text} - Rating: $_selectedRating⭐',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved: ${_titleController.text}')));

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Movie/Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(labelText: 'Title'),
              keyboardType: TextInputType.text,
            ),
            Row(
              children: [
                DropdownButton(
                  value: _selectedGenre,
                  items: Genre.values
                      .map(
                        (genre) => DropdownMenuItem(
                          value: genre,
                          child: Text(genre.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedGenre = value;
                    });
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton(
                  value: _selectedStatus,
                  items: WatchStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Rating:'),
                const SizedBox(width: 16),
                DropdownButton(
                  value: _selectedRating,
                  items: [0, 1, 2, 3, 4, 5]
                      .map(
                        (rating) => DropdownMenuItem(
                          value: rating,
                          child: Text('$rating'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedRating = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _saveItem, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
