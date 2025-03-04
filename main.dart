import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:on_app/notifiers/statistics.dart';
import 'package:on_app/screens/on_screen.dart';
import 'package:on_app/screens/view_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/cloud_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "secrets");
  } catch (e) {
    throw Exception('Missing secrets file in root directory');
  }
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
  );
  initializeDateFormatting();

  runApp(
    ChangeNotifierProvider(create: (context) => Statistics(), child: OnApp()),
  );
}

class OnApp extends StatelessWidget {
  const OnApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
      title: 'On!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/on': (context) => OnScreen(),
        '/view': (context) => ViewScreen(),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OnScreen(),
    const ViewScreen(),
    const CloudScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top),
            label: 'Logg',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.view_agenda), label: 'Vis'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_sync), label: 'Sky'),
        ],
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryFixedVariant,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
