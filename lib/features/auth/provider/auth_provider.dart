import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocrtestdemo/commons/custom_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailAuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Sign Up Method
  Future<void> signUp({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      _setLoading(true); // Start loading

      // Validate input
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: "Empty Fields",
          message: "Please fill in all fields.",
        );
        return;
      }

      if (password != confirmPassword) {
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: "Password Mismatch",
          message: "Passwords do not match.",
        );
        return;
      }

      // Attempt to sign up
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {'username': username.trim()},
      );

      if (response.user != null) {
        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: "Registration Success",
          message: "Account created successfully!",
        );
        // Navigate to home screen
        context.goNamed("homeScreen");
      } else {
        throw Exception("Unknown error occurred.");
      }
    } on AuthException catch (e) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: "Authentication Error",
        message: e.message ?? "Unknown error occurred.",
      );
    } catch (e) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: "Error",
        message: "An unexpected error occurred. Please try again.",
      );
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  /// Sign In Method
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true); // Start loading

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: "Empty Fields",
          message: "Please fill in all fields.",
        );
        return;
      }

      // Attempt to sign in
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: "Sign In Success",
          message: "Welcome back!",
        );
        // Navigate to home screen
        context.goNamed("homeScreen");
      } else {
        throw Exception("Invalid email or password.");
      }
    } on AuthException catch (e) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: "Authentication Error",
        message: e.message ?? "Invalid email or password.",
      );
    } catch (e) {
      CustomFailureSnackBar.showFailureAwesomeSnackBar(
        context: context,
        title: "Error",
        message: "An unexpected error occurred. Please try again.",
      );
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  /// Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
