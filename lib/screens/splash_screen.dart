import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/providers/auth_provider.dart';
import 'package:uas_ambw/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirstLaunch = await _storageService.isFirstLaunch();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.initialize();

    Future.delayed(const Duration(seconds: 2), () {
      if (isFirstLaunch) {
        context.go('/get-started');
      } else if (authProvider.isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.event_note,
                  size: 120,
                  color: Colors.blue,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Daily Planner',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize your day with ease',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
