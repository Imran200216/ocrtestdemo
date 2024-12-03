import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';

class CustomAlertDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const CustomAlertDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.subTitleColor,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.subTitleColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onDelete,
          child: Text(
            "Delete",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
