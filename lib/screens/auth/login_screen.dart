import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/providers/auth_provider.dart';
import 'package:uas_ambw/utils/utils.dart';
import 'package:uas_ambw/widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Clear errors when user starts typing
    _emailController.addListener(_clearErrors);
    _passwordController.addListener(_clearErrors);
  }

  @override
  void dispose() {
    _emailController.removeListener(_clearErrors);
    _passwordController.removeListener(_clearErrors);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.error != null) {
      authProvider.clearError();
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        context.go('/home');
      } else if (mounted && authProvider.error != null) {
        // The error will be displayed in the UI container
        // Optionally also show a brief snackbar for immediate feedback
        String errorMessage = _parseErrorMessage(authProvider.error!);
        if (errorMessage.contains('Invalid email or password') ||
            errorMessage.contains('No account found')) {
          // Only show snackbar for critical errors, others are shown in the container
          Utils.showSnackBar(context, errorMessage, isError: true);
        }
      }
    }
  }

  // Helper method to parse and provide user-friendly error messages
  String _parseErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('invalid login credentials') ||
        lowerError.contains('invalid_credentials') ||
        lowerError.contains('email not confirmed') ||
        lowerError.contains('authentication failed')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    } else if (lowerError.contains('email not found') ||
        lowerError.contains('user not found')) {
      return 'No account found with this email address. Please sign up first.';
    } else if (lowerError.contains('wrong password') ||
        lowerError.contains('incorrect password')) {
      return 'Incorrect password. Please try again.';
    } else if (lowerError.contains('too many requests') ||
        lowerError.contains('rate limit')) {
      return 'Too many login attempts. Please wait a moment and try again.';
    } else if (lowerError.contains('network') ||
        lowerError.contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (lowerError.contains('email') && lowerError.contains('invalid')) {
      return 'Please enter a valid email address.';
    } else {
      return 'Sign in failed. Please check your credentials and try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/');
            }
          },
          tooltip: 'Back',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App logo or icon
                  Icon(
                    Icons.event_note,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // App name
                  const Text(
                    'Daily Planner',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Error message container
                  if (authProvider.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _parseErrorMessage(authProvider.error!),
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Email field
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Utils.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: Utils.validatePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Sign In',
                      onPressed: _login,
                      isLoading: authProvider.isLoading,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Create account link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          context.go('/signup');
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
