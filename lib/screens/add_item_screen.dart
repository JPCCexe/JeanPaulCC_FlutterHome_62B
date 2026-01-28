import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/model/watchlist_item.dart';
import 'package:watchlist_manager_movies_series/services/notification_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Import for Fire base analytics
import 'package:firebase_analytics/firebase_analytics.dart';

// Stateful widget for adding new movies/series to the watchlist
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
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Opens camera to capture an image for the watchlist item
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    // Log for camera being used
    FirebaseAnalytics.instance.logEvent(name: 'camera_used');

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  Future<void> _saveItem() async {
    // Validate that title is not empty
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
      imagePath: _selectedImage?.path,
    );

    widget.onAddItem(newItem);

    // Log analytics event
    FirebaseAnalytics.instance.logEvent(
      name: 'add_watchlist_item',
      parameters: {
        'item_title': _titleController.text,
        'item_genre': _selectedGenre.name,
        'rating': _selectedRating,
        'status': _selectedStatus.name,
      },
    );

    // Show local notification for successful addition
    await NotificationService.showNotification(
      'New ${_selectedGenre.name.toUpperCase()} Added!',
      '${_titleController.text} - Rating: $_selectedRating⭐',
    );

    if (!mounted) return;

    // Display confirmation SnackBar
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

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedImage == null
                        ? 'No image taken'
                        : 'A Photo is captured',
                    style: TextStyle(
                      color: _selectedImage == null
                          ? Colors.grey
                          : Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _takePicture,
                  icon: const Icon(Icons.camera),
                  label: const Text('Take Photo'),
                ),
              ],
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
