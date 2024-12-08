import 'package:go_router/go_router.dart';
import 'package:ocrtestdemo/features/auth/forget_password_auth/forget_password_screen.dart';
import 'package:ocrtestdemo/features/auth/login_auth/login_auth_screen.dart';
import 'package:ocrtestdemo/features/auth/register_auth/register_auth_screen.dart';
import 'package:ocrtestdemo/features/home/home_desktop_screen.dart';
import 'package:ocrtestdemo/features/home/home_mobile_screen.dart';
import 'package:ocrtestdemo/features/home/home_screen.dart';
import 'package:ocrtestdemo/features/home/home_tablet_screen.dart';
import 'package:ocrtestdemo/features/result/result_desktop_screen.dart';
import 'package:ocrtestdemo/features/result/result_mobile_screen.dart';
import 'package:ocrtestdemo/features/result/result_screen.dart';
import 'package:ocrtestdemo/features/result/result_tablet_screen.dart';
import 'package:ocrtestdemo/features/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      /// Splash screen
      GoRoute(
        path: "/",
        name: "splashScreen",
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      /// Login screen
      GoRoute(
        path: "/loginScreen",
        name: "loginScreen",
        builder: (context, state) {
          return const LoginAuthScreen();
        },
        redirect: (context, state) {
          final user = Supabase.instance.client.auth.currentUser;

          // Check authentication status
          if (user != null) {
            // User is authenticated, redirect to home screen
            return '/homeScreen';
          } else {
            // User is not authenticated, redirect to login screen
            return '/loginScreen';
          }
        },
      ),

      /// Register screen
      GoRoute(
        path: "/registerScreen",
        name: "registerScreen",
        builder: (context, state) {
          return const RegisterAuthScreen();
        },
        redirect: (context, state) {
          final user = Supabase.instance.client.auth.currentUser;

          // If the user is authenticated, redirect to home screen
          if (user != null) {
            return '/homeScreen';
          }
          return null; // Proceed to the register screen
        },
      ),

      /// Forget password screen
      GoRoute(
        path: "/forgetPasswordScreen",
        name: "forgetPasswordScreen",
        builder: (context, state) {
          return const ForgetPasswordScreen();
        },
      ),

      /// Home screen (Common Screen)
      GoRoute(
        path: "/homeScreen",
        name: "homeScreen",
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      /// Home Screen (mobile screen)
      GoRoute(
        path: "/homeMobileScreen",
        name: "homeMobileScreen",
        builder: (context, state) {
          return const HomeMobileScreen();
        },
      ),

      /// Home Screen (web screen)
      GoRoute(
        path: "/homeDesktopScreen",
        name: "homeDesktopScreen",
        builder: (context, state) {
          return const HomeDesktopScreen();
        },
      ),

      /// Home Screen (Tablet Screen)
      GoRoute(
        path: "/homeTabletScreen",
        name: "homeTabletScreen",
        builder: (context, state) {
          return const HomeTabletScreen();
        },
      ),

      /// Result screen (Common screen)
      GoRoute(
        path: "/resultScreen",
        name: "resultScreen",
        builder: (context, state) {
          return const ResultScreen();
        },
      ),

      /// Result screen (mobile screen)
      GoRoute(
        path: "/resultMobileScreen",
        name: "resultMobileScreen",
        builder: (context, state) {
          return const ResultMobileScreen();
        },
      ),

      /// Result screen (desktop screen)
      GoRoute(
        path: "/resultDesktopScreen",
        name: "resultDesktopScreen",
        builder: (context, state) {
          return const ResultDesktopScreen();
        },
      ),

      /// Result Screen (tabletScreen)
      GoRoute(
        path: "/resultTabScreen",
        name: "resultTabScreen",
        builder: (context, state) {
          return const ResultTabletScreen();
        },
      ),
    ],
  );
}
