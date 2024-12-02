import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashDesktopScreen extends StatefulWidget {
  const SplashDesktopScreen({super.key});

  @override
  State<SplashDesktopScreen> createState() => _SplashDesktopScreenState();
}

class _SplashDesktopScreenState extends State<SplashDesktopScreen> {
  @override
  void initState() {
    super.initState();

    // Timer to navigate to the LoginScreen after 4 seconds
    Timer(const Duration(seconds: 3), () {
      context.goNamed("loginScreen");
    });
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
