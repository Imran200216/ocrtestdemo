import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/commons/custom_ocr_text_field_with_btn.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';

class ResultTabletScreen extends StatelessWidget {
  const ResultTabletScreen({super.key});

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
      'Country',
      'City'
    ];

    return Center(
      child: Container(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.only(
          top: 50,
          left: 24,
          right: 24,
          bottom: 50,
        ),
        width: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

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
              textAlign: TextAlign.start,
              "Following data are extracted from the business card*, Some datas are sensitive contents!",
              style: GoogleFonts.poppins(
                color: AppColors.subTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),

            /// Dynamically generate 10 text fields
            ...labels.map(
                  (label) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CustomOCRTextFieldWithBtn(
                  labelText: label,
                  hintText: 'Enter $label',
                  prefixIcon: Icons.auto_awesome_outlined,
                  suffixIcon: Icons.copy,
                  onSuffixIconPressed: () {
                    // Handle copy action for this specific field
                  },
                  onButtonPressed: () {
                    // Handle button action for this specific field
                  },
                  buttonText: 'Select',
                  borderColor: AppColors.subTitleColor,
                  buttonColor: AppColors.primaryColor,
                  buttonTextColor: AppColors.secondaryColor,
                  controller: TextEditingController(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
