import 'package:flutter/material.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:ocrtestdemo/features/home/home_desktop_screen.dart';
import 'package:ocrtestdemo/features/home/home_mobile_screen.dart';
import 'package:ocrtestdemo/features/home/home_tablet_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  const HomeDesktopScreen()
                else if (size.width >= 650 && size.width < 1100)
                  const HomeTabletScreen()
                else
                  const HomeMobileScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
