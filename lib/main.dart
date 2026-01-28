import 'package:flutter/material.dart';
import 'package:watchlist_manager_movies_series/screens/home_screen.dart';
import 'package:watchlist_manager_movies_series/services/notification_service.dart';

//Firebase Import
import 'package:firebase_core/firebase_core.dart'; // ADD THIS LINE
import 'firebase_options.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 231, 76, 60),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: const HomeScreen());
  }
}
