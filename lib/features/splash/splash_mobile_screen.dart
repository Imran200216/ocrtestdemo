import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:ocrtestdemo/features/auth/service/auth_service.dart';

class SplashMobileScreen extends StatefulWidget {
  const SplashMobileScreen({super.key});

  @override
  State<SplashMobileScreen> createState() => _SplashMobileScreenState();
}

class _SplashMobileScreenState extends State<SplashMobileScreen> {
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
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
