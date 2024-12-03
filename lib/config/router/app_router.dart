import 'package:go_router/go_router.dart';
import 'package:ocrtestdemo/features/auth/forget_password_auth/forget_password_screen.dart';
import 'package:ocrtestdemo/features/auth/login_auth/login_auth_screen.dart';
import 'package:ocrtestdemo/features/auth/register_auth/register_auth_screen.dart';
import 'package:ocrtestdemo/features/home/home_screen.dart';
import 'package:ocrtestdemo/features/result/result_screen.dart';
import 'package:ocrtestdemo/features/splash_screen/splash_screen.dart';
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

      /// Login screen
      GoRoute(
        path: "/loginScreen",
        name: "loginScreen",
        builder: (context, state) {
          return const LoginAuthScreen();
        },
        redirect: (context, state) {
          final user = Supabase.instance.client.auth.currentUser;

          // If the user is authenticated, redirect to home screen
          if (user != null) {
            return '/homeScreen';
          }
          return null; // Proceed to the login screen
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

      /// Home screen
      GoRoute(
        path: "/homeScreen",
        name: "homeScreen",
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      /// Result screen
      GoRoute(
        path: "/resultScreen",
        name: "resultScreen",
        builder: (context, state) {
          return const ResultScreen();
        },
      ),
    ],
  );
}
