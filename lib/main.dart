import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FitJourneyApp(),
    ),
  );
}

class FitJourneyApp extends StatelessWidget {
  const FitJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitJourney',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PlaceholderScreen(title: 'Home'),
    const PlaceholderScreen(title: 'Workout'),
    const PlaceholderScreen(title: 'Nutrition'),
    const PlaceholderScreen(title: 'Progress'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Workout'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Nutrition'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
