import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/config/app_config.dart';
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
    _checkFirstLaunchAndNavigate();
  }

  Future<void> _checkFirstLaunchAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if this is the first launch
    final isFirstLaunch = await _storageService.isFirstLaunch();
    
    // Initialize auth provider
    await authProvider.initialize();

    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (isFirstLaunch) {
        // First launch - show get started screen
        context.go('/get-started');
      } else if (authProvider.isAuthenticated) {
        // Not first launch and user is authenticated - go to home
        context.go('/home');
      } else {
        // Not first launch but user is not authenticated - go to login
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // Very light blue-gray
              Color(0xFFE2E8F0), // Light blue-gray
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern logo container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConfig.primaryColor,
                      AppConfig.secondaryColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConfig.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Daily Planner',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppConfig.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Organize your day with ease',
                style: TextStyle(
                  fontSize: 18,
                  color: AppConfig.secondaryTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConfig.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
