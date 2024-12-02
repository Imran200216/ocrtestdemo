import 'package:go_router/go_router.dart';
import 'package:ocrtestdemo/screens/auth/forget_password_auth/forget_password_screen.dart';
import 'package:ocrtestdemo/screens/auth/login_auth/login_auth_screen.dart';
import 'package:ocrtestdemo/screens/auth/register_auth/register_auth_screen.dart';
import 'package:ocrtestdemo/screens/home/home_screen.dart';
import 'package:ocrtestdemo/screens/result/result_screen.dart';
import 'package:ocrtestdemo/screens/splash_screen/splash_screen.dart';

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      /// splash screen
      GoRoute(
        path: "/",
        name: "splashScreen",
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      /// auth screen (Login screen)
      GoRoute(
        path: "/loginScreen",
        name: "loginScreen",
        builder: (context, state) {
          return const LoginAuthScreen();
        },
      ),

      /// auth screen (register screen)
      GoRoute(
        path: "/registerScreen",
        name: "registerScreen",
        builder: (context, state) {
          return const RegisterAuthScreen();
        },
      ),

      /// auth screen (forget screen)
      GoRoute(
        path: "/forgetPasswordScreen",
        name: "forgetPasswordScreen",
        builder: (context, state) {
          return const ForgetPasswordScreen();
        },
      ),

      /// home screen
      GoRoute(
        path: "/homeScreen",
        name: "homeScreen",
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      /// result screen
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
