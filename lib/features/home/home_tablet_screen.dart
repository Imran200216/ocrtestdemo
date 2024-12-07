import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:ocrtestdemo/commons/custom_alert_delete_dialog.dart';
import 'package:ocrtestdemo/commons/custom_clear_image_btn.dart';
import 'package:ocrtestdemo/commons/custom_icon_btn.dart';
import 'package:ocrtestdemo/commons/custom_snack_bar.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:ocrtestdemo/features/auth/provider/auth_provider.dart';
import 'package:ocrtestdemo/features/result/provider/ocr_provider.dart';
import 'package:provider/provider.dart';

class HomeTabletScreen extends StatelessWidget {
  const HomeTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// OCR Provider
    final ocrProvider = Provider.of<OCRProvider>(context);

    /// Email auth provider
    final emailAuthProvider = Provider.of<EmailAuthProvider>(context);

    /// Current email
    final currentEmail = emailAuthProvider.getCurrentUserEmail();

    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          left: 44,
          right: 44,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              "Hi there, ${currentEmail.toString()}",
              style: GoogleFonts.poppins(
                color: AppColors.titleBgColor,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Let's have fun with OCR!",
              style: GoogleFonts.poppins(
                color: AppColors.gradientColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            ocrProvider.isProcessing
                ? LottieBuilder.asset(
              "assets/animation/business-card-processing.json",
              height: 500,
              width: 500,
              fit: BoxFit.cover,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // File picking UI
                InkWell(
                  onTap: () {
                    if (ocrProvider.pickedFileBytes == null &&
                        ocrProvider.pickedFilePath == null) {
                      ocrProvider.pickFile(context);
                    }
                  },
                  child: DottedBorder(
                    color: const Color(0xFF51BDED),
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(4),
                    child: Container(
                      height: 280,
                      width: 700,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFFF2F7FF),
                      ),
                      child: Center(
                        child: ocrProvider.isLoading
                            ? Lottie.asset(
                            "assets/animation/image-loading.json")
                            : ocrProvider.pickedFileBytes != null
                            ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(4),
                              child: InstaImageViewer(
                                child: Image.memory(
                                  ocrProvider.pickedFileBytes!,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: CustomClearImageBtn(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDeleteDialog(
                                        title: "Delete Image!",
                                        content:
                                        "Are you sure you want to delete the image?",
                                        onCancel: () {
                                          Navigator.pop(
                                              context);
                                        },
                                        onDelete: () {
                                          ocrProvider.clearFile(
                                              context);
                                          Navigator.pop(
                                              context);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                            : ocrProvider.pickedFilePath != null &&
                            (ocrProvider.pickedFilePath!
                                .endsWith(".jpg") ||
                                ocrProvider.pickedFilePath!
                                    .endsWith(".jpeg") ||
                                ocrProvider.pickedFilePath!
                                    .endsWith(".png"))
                            ? InstaImageViewer(
                          child: Image.file(
                            File(ocrProvider
                                .pickedFilePath!),
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        )
                            : Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icon/upload.svg",
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Drag and drop file here or",
                                  style:
                                  GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: const Color(
                                        0xFF111829),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ocrProvider
                                        .pickFile(context);
                                  },
                                  child: Text(
                                    "Choose file",
                                    style:
                                    GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.w500,
                                      color: const Color(
                                          0xFF111829),
                                      decoration:
                                      TextDecoration
                                          .underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Supported format: JPG, JPEG, PNG",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8992A2),
                        ),
                      ),
                      Text(
                        "Maximum size: 25MB",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8992A2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // OCR button
                CustomIconBtn(
                  btnHeight: 50,
                  btnWidth: 700,
                  btnColor: AppColors.primaryColor,
                  onTap: () async {
                    // Ensure the file is picked
                    if (ocrProvider.pickedFileBytes != null ||
                        ocrProvider.pickedFilePath != null) {
                      try {
                        print(
                            "Picked file path: ${ocrProvider.pickedFilePath}"); // Debug log

                        // Start OCR processing, show animation
                        ocrProvider
                            .setProcessing(true); // Set processing state

                        // Upload the file first
                        await ocrProvider.uploadFile(context);

                        // Proceed with the OCR processing after the upload
                        if (ocrProvider.pickedFilePath != null) {
                          final image = File(ocrProvider.pickedFilePath!);
                          print(
                              "Processing file: ${image.path}"); // Debug log

                          // Show the Lottie animation and process the business card
                          await ocrProvider.processBusinessCard(
                              context, image);

                          // Set processing to false after the process is done
                          ocrProvider.setProcessing(false);

                          // After processing is complete, navigate to the result screen
                          context.pushNamed("resultScreen");
                        } else {
                          throw Exception(
                              'No valid image file path found!');
                        }
                      } catch (error) {
                        // Handle errors gracefully and set processing to false in case of error
                        ocrProvider.setProcessing(false);
                        CustomFailureSnackBar.showFailureAwesomeSnackBar(
                          context: context,
                          title: 'Error!',
                          message: error.toString(),
                        );
                      }
                    } else {
                      // Show failure snack bar if no image is picked
                      CustomFailureSnackBar.showFailureAwesomeSnackBar(
                        context: context,
                        title: 'Error!',
                        message: 'Please pick an image to proceed!',
                      );
                    }
                  },
                  btnWidget: ocrProvider.isProcessing
                      ? CircularProgressIndicator(
                    color: AppColors.secondaryColor,
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.secondaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Extract entities from card",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
