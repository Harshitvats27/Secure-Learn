import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Reviewer login ke liye zaroori
import '../services/firebase_auth_services.dart';
import '../widgets/google_sigin_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;

  // Controllers for Reviewer Login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final user = await _authService.signInWithGoogle();

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google Sign-In failed. Please try again."),
        ),
      );
    }
  }

  // --- REVIEWER LOGIN FUNCTION ---
  Future<void> _handleReviewerLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Reviewer Login failed."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- REVIEWER LOGIN DIALOG BOX ---
  void _showReviewerLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("App Reviewer Login"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleReviewerLogin();
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // YAHAN HAI TERA DARK MODE STATE BARKARAR!
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Background color bhi dark mode ke hisaab se adjust ho jayega
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated cyber security illustration
                Lottie.asset(
                  'assets/animation/datasecurity.json',
                  height: 250,
                  repeat: true,
                ),

                const SizedBox(height: 20),

                Text(
                  "Welcome to SecureLearn",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    // Text color mapped with Dark mode
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Learn Cybersecurity with fun & gamification",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    // Subtitle text color mapped with Dark mode
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // Show loading or Google Sign-In Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                  children: [
                    GoogleSignInButton(onPressed: _handleGoogleSignIn),
                    const SizedBox(height: 16),

                    // Subtle button for Play Store Reviewer
                    TextButton(
                      onPressed: _showReviewerLoginDialog,
                      child: Text(
                        "App Reviewer Login",
                        style: TextStyle(
                          // Button text color mapped with Dark mode
                          color: isDark ? Colors.white54 : Colors.black54,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}