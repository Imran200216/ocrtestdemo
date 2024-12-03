import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';

/// success snack bar
class CustomSuccessSnackBar {
  static void showSuccessAwesomeSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration =
        const Duration(seconds: 3), // Default duration of 3 seconds
  }) {
    final materialBanner = MaterialBanner(
      elevation: 0,
      dividerColor: AppColors.transparentColor,
      backgroundColor: AppColors.transparentColor,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: title,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w600,
        ),
        message: message,
        messageTextStyle: GoogleFonts.poppins(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w500,
        ),
        contentType: ContentType.success,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);

    // Automatically dismiss the snackbar after the specified duration
    Future.delayed(duration, () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }
}

/// failure snack bar
class CustomFailureSnackBar {
  static void showFailureAwesomeSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration =
        const Duration(seconds: 3), // Default duration of 3 seconds
  }) {
    final materialBanner = MaterialBanner(
      dividerColor: AppColors.transparentColor,
      elevation: 0,
      backgroundColor: AppColors.transparentColor,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: title,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w600,
        ),
        message: message,
        messageTextStyle: GoogleFonts.poppins(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w500,
        ),
        contentType: ContentType.failure,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);

    // Automatically dismiss the snackbar after the specified duration
    Future.delayed(duration, () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }
}
