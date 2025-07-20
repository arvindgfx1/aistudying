import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/camera_tutor_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/subjects_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/region_selection_screen.dart';
import 'screens/books_screen.dart';
import 'screens/login_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Print error to console
    print('Flutter Error: ${details.exception}');
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Center(
        child: Text(
          'Error: ${details.exception}',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  };

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web,
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    print('Firebase initialized');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const StudyCamApp());
}

class StudyCamApp extends StatelessWidget {
  const StudyCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI StudyCam Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: true,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static final List<Widget> _screens = <Widget>[
    DashboardScreen(),
    SubjectsScreen(),
    BooksScreen(),
    ChatScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Subjects'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        ],
      ),
      floatingActionButton: _selectedIndex != 3
          ? FloatingActionButton(
              onPressed: () => setState(() => _selectedIndex = 3),
              child: const Icon(Icons.chat),
              tooltip: 'Study ChatBot',
            )
          : null,
    );
  }
}

// DashboardScreen is now imported from dashboard_screen.dart

// SubjectsScreen is now imported from subjects_screen.dart

// ChatScreen is now imported from chat_screen.dart

// ProgressScreen is now imported from progress_screen.dart

// SettingsScreen removed - replaced with BooksScreen
