import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:ocrtestdemo/features/auth/service/auth_service.dart';

class SplashDesktopScreen extends StatefulWidget {
  const SplashDesktopScreen({super.key});

  @override
  State<SplashDesktopScreen> createState() => _SplashDesktopScreenState();
}

class _SplashDesktopScreenState extends State<SplashDesktopScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    // Timer to navigate to the appropriate screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      _navigateBasedOnAuthStatus();
    });
  }

  void _navigateBasedOnAuthStatus() {
    final userEmail = _authService.getCurrentUserEmail();

    if (userEmail != null && userEmail.isNotEmpty) {
      // User is signed in; navigate to the HomeScreen
      context.goNamed("homeScreen");
    } else {
      // User is not signed in; navigate to the LoginScreen
      context.goNamed("loginScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            "assets/animation/splash.json",
            height: 280,
            width: 280,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
