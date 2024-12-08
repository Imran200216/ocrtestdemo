import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/commons/custom_icon_btn.dart';
import 'package:ocrtestdemo/commons/custom_ocr_text_field_with_btn.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';

class ResultDesktopScreen extends StatelessWidget {
  const ResultDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of label texts for the 10 text fields
    final List<String> labels = [
      'Name',
      'Address',
      'Phone Number',
      'Email',
      'Company Name',
      'Designation',
      'Website',
      'Department',
    ];

    return Center(
      child: Container(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.only(
          top: 50,
          bottom: 50,
        ),
        width: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              "Extracted business card data",
              style: GoogleFonts.poppins(
                color: AppColors.titleBgColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            /// Sub-title
            Text(
              "Following data are extracted from the business card*,\nSome datas are sensitive contents!",
              style: GoogleFonts.poppins(
                color: AppColors.subTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),

            /// name text field
            CustomOCRTextField(
              labelText: "Name",
              hintText: "name",
              prefixIcon: Icons.auto_awesome_outlined,
              suffixIcon: Icons.copy,
              onSuffixIconPressed: () {},
            ),

            const SizedBox(
              height: 20,
            ),

            CustomIconBtn(
              btnWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 16,
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Back to Home",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
              onTap: () {},
              btnHeight: 48,
              btnWidth: double.infinity,
              btnColor: AppColors.gradientColor,
            )
          ],
        ),
      ),
    );
  }
}
