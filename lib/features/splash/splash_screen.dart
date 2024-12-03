import 'package:flutter/material.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:ocrtestdemo/features/splash/splash_desktop_screen.dart';
import 'package:ocrtestdemo/features/splash/splash_mobile_screen.dart';
import 'package:ocrtestdemo/features/splash/splash_tablet_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Media query
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: Center(
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
                  const SplashDesktopScreen()
                else if (size.width >= 650 && size.width < 1100)
                  const SplashTabletScreen()
                else
                  const SplashMobileScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
