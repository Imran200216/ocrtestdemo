import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ocrtestdemo/components/custom_alert_delete_dialog.dart';
import 'package:ocrtestdemo/components/custom_clear_image_btn.dart';
import 'package:ocrtestdemo/components/custom_icon_btn.dart';
import 'package:ocrtestdemo/components/custom_snack_bar.dart';
import 'package:ocrtestdemo/constants/colors.dart';
import 'package:ocrtestdemo/provider/ocr_provider.dart';
import 'package:provider/provider.dart';

class HomeDesktopScreen extends StatelessWidget {
  const HomeDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// OCR Provider
    final ocrProvider = Provider.of<OCRProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// title
          Text(
            "Hi there, Anirudhan",
            style: GoogleFonts.poppins(
              color: AppColors.titleBgColor,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 2,
          ),

          /// sub title
          Text(
            "Let's have fun with OCR!",
            style: GoogleFonts.poppins(
              color: AppColors.gradientColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          /// Dotted border
          InkWell(
            onTap: () {
              /// Only pick the file if no image is selected already.
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
                          "assets/animation/image-loading.json",
                          fit: BoxFit.cover,
                        )
                      : ocrProvider.pickedFileBytes != null
                          ? Stack(
                              children: [
                                ///image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.memory(
                                    ocrProvider.pickedFileBytes!, // For web
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),

                                /// clear image btn
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: CustomClearImageBtn(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomAlertDeleteDialog(
                                            title: "Delete Image!",
                                            content:
                                                "Are you sure, you want to delete the image?",
                                            onCancel: () {
                                              context.pop();
                                            },
                                            onDelete: () {
                                              /// clear image
                                              ocrProvider.clearFile(context);
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
                              ? Image.file(
                                  File(ocrProvider
                                      .pickedFilePath!), // For native
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          "Drag and Drop file here or",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF111829),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ocrProvider.pickFile(context);
                                          },
                                          child: Text(
                                            "Choose file",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF111829),
                                              decoration:
                                                  TextDecoration.underline,
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

          /// supported description
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

          const SizedBox(
            height: 50,
          ),

          /// OCR button
          CustomIconBtn(
            btnHeight: 50,
            btnWidth: 700,
            btnColor: AppColors.primaryColor,
            onTap: () {
              if (ocrProvider.pickedFileBytes != null ||
                  (ocrProvider.pickedFilePath != null &&
                      (ocrProvider.pickedFilePath!.endsWith(".jpg") ||
                          ocrProvider.pickedFilePath!.endsWith(".jpeg") ||
                          ocrProvider.pickedFilePath!.endsWith(".png")))) {
                context.pushNamed("resultScreen");
              } else {
                CustomFailureSnackBar.showFailureAwesomeSnackBar(
                  context: context,
                  title: 'Error!',
                  message: 'Please pick an image to proceed!',
                );
              }
            },
            btnWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppColors.secondaryColor,
                ),
                const SizedBox(
                  width: 12,
                ),
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
    );
  }
}
