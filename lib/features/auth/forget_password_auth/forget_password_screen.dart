import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocrtestdemo/features/auth/forget_password_auth/forget_password_desktop_screen.dart';
import 'package:ocrtestdemo/features/auth/forget_password_auth/forget_password_mobile_screen.dart';
import 'package:ocrtestdemo/features/auth/forget_password_auth/forget_password_tablet_screen.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

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
                      const ForgetPasswordDesktopScreen()
                    else if (size.width >= 650 && size.width < 1100)
                      const ForgetPasswordTabletScreen()
                    else
                      const ForgetPasswordMobileScreen(),
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
