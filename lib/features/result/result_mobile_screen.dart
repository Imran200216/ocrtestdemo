import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultMobileScreen extends StatelessWidget {
  const ResultMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// supabase initialization
    final supabase = Supabase.instance.client;

    /// fetching the data form DB
    final ocrDetailsStream = supabase.from("business_card_data").stream(
      primaryKey: ['id'],
    );


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

            StreamBuilder(
              stream: ocrDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final ocrData = snapshot.data!;

                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ocrData.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 14,
                      );
                    },
                    itemBuilder: (context, index) {
                      /// to get the project documents
                      final ocr = ocrData[index];
                      final ocrId = ocr['id'].toString();

                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.pink.shade100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 22,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(ocr['phoneNumber'] ?? "No phone number"),
                              Text(ocr['emailAddress'] ?? "No email address"),
                              Text(ocr['companyName'] ?? "No company name"),
                              Text(ocr['personDesignation'] ??
                                  "No person designation"),
                              Text(ocr['companyWebsite'] ??
                                  "No company website"),
                              Text(ocr['others'] ?? "No others"),
                              Text(ocr['personName'] ?? "No person name"),
                              Text(ocr['companyAddress'] ??
                                  "No company address"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No projects found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
