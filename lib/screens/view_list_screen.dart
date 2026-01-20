import 'package:flutter/material.dart';

class ViewListScreen extends StatelessWidget {
  const ViewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Watchlist')),
      body: const Center(child: Text('View List Screen')),
    );
  }
}
