import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ambw/screens/add_activity_screen.dart';
import 'package:uas_ambw/screens/auth/login_screen.dart';
import 'package:uas_ambw/screens/auth/signup_screen.dart';
import 'package:uas_ambw/screens/get_started_screen.dart';
import 'package:uas_ambw/screens/home_screen.dart';
import 'package:uas_ambw/screens/splash_screen.dart';
import 'package:uas_ambw/services/storage_service.dart';

class AppRouter {
  static final StorageService _storageService = StorageService();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/get-started',
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/add-activity',
        builder: (context, state) {
          // Check if there's an activity to edit in the state
          final activity = state.extra;
          return AddActivityScreen(activity: activity);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
    redirect: (context, state) async {
      // Check if it's the app's first launch
      if (state.path == '/') {
        return null; // Let the splash screen handle redirections
      }
      return null;
    },
  );
}
