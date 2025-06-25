import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_ambw/config/app_config.dart';
import 'package:uas_ambw/services/storage_service.dart';
import 'package:uas_ambw/widgets/common_widgets.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _pageController = PageController();
  final StorageService _storageService = StorageService();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Welcome to Daily Planner',
      'description':
          'The simplest way to organize your day and keep track of your activities.',
      'icon': Icons.event_note,
    },
    {
      'title': 'Create Activities',
      'description':
          'Add your daily activities with specific time and category to stay organized.',
      'icon': Icons.add_task,
    },
    {
      'title': 'Track Progress',
      'description':
          'Mark activities as completed when done to track your productivity.',
      'icon': Icons.check_circle,
    },
    {
      'title': 'Sync Across Devices',
      'description':
          'Your activities are securely stored in the cloud and accessible from anywhere.',
      'icon': Icons.cloud_sync,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    // Mark first launch as completed
    await _storageService.setFirstLaunchDone();

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(
                      title: _onboardingData[index]['title'],
                      description: _onboardingData[index]['description'],
                      icon: _onboardingData[index]['icon'],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppConfig.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _currentPage < _onboardingData.length - 1
                      ? 'Next'
                      : 'Get Started',
                  onPressed: () {
                    if (_currentPage < _onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 120, color: AppConfig.primaryColor),
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: AppConfig.secondaryTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
