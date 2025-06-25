import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_ambw/config/app_config.dart';
import 'package:uas_ambw/config/app_router.dart';
import 'package:uas_ambw/providers/activity_provider.dart';
import 'package:uas_ambw/providers/auth_provider.dart';
import 'package:uas_ambw/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  final storageService = StorageService();
  await storageService.initHive();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://zszpyvhodssokbamknen.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzenB5dmhvZHNzb2tiYW1rbmVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA4MjQwOTcsImV4cCI6MjA2NjQwMDA5N30.m-0BGkY1Zh9oQi1IRHH2xm9Y4iYcXtS40IYkHLwakDI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // You can switch between the Daily Planner app and the Todos app by
    // commenting out one and uncommenting the other

    // Original Daily Planner app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
      ],
      child: MaterialApp.router(
        title: 'Daily Planner',
        theme: AppConfig.getTheme(),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );

    // Simple Todos app for testing Supabase connection
    // return const MaterialApp(
    //   title: 'Todos',
    //   home: HomePage(),
    // );
  }
}

// Simple Todos page for testing Supabase connection
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client.from('todos').select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos from Supabase')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: ((context, index) {
              final todo = todos[index];
              return ListTile(title: Text(todo['name']));
            }),
          );
        },
      ),
    );
  }
}
