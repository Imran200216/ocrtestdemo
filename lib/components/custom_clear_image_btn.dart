import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/constants/colors.dart';

class CustomClearImageBtn extends StatelessWidget {
  final VoidCallback onTap;

  const CustomClearImageBtn({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.deleteBtnBgColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline,
                color: AppColors.secondaryColor,
                size: 14,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Clear Image",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
