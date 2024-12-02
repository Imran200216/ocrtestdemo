import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocrtestdemo/screens/auth/register_auth/register_auth_desktop_screen.dart';
import 'package:ocrtestdemo/screens/auth/register_auth/register_auth_mobile_screen.dart';
import 'package:ocrtestdemo/screens/auth/register_auth/register_auth_tablet_screen.dart';

class RegisterAuthScreen extends StatelessWidget {
  const RegisterAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Media query
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background container
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/images/svg/auth-bg.svg",
              fit: BoxFit.cover,
            ),
          ),
          // Login content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1400,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (size.width >= 1100)
                      const RegisterAuthDesktopScreen()
                    else if (size.width >= 650 && size.width < 1100)
                      const RegisterAuthTabletScreen()
                    else
                      const RegisterAuthMobileScreen(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
