import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/commons/custom_auth_text_field.dart';
import 'package:ocrtestdemo/commons/custom_icon_btn.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:ocrtestdemo/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterAuthDesktopScreen extends StatelessWidget {
  const RegisterAuthDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// controllers
    TextEditingController userNameRegisterController = TextEditingController();
    TextEditingController emailRegisterController = TextEditingController();
    TextEditingController passwordRegisterController = TextEditingController();
    TextEditingController confirmPasswordRegisterController =
        TextEditingController();

    /// email auth provider
    final emailAuthProvider = Provider.of<EmailAuthProvider>(context);

    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          width: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.white.withOpacity(0.3),
            border: Border.all(
              width: 2,
              color: Colors.white30,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(
              left: 80,
              right: 80,
              top: 50,
              bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// sign up title
                Text(
                  "Register Up",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                /// email text
                Text(
                  "Username",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBtnColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                /// username text field
                CustomAuthTextField(
                  controller: userNameRegisterController,
                  keyboardType: TextInputType.name,
                  hintText: "Samantha",
                ),
                const SizedBox(
                  height: 12,
                ),

                /// email text
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBtnColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                /// email text field
                CustomAuthTextField(
                  controller: emailRegisterController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "User@gmail.com",
                ),
                const SizedBox(
                  height: 12,
                ),

                /// password text
                Text(
                  "Password",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBtnColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                /// password text field
                CustomAuthTextField(
                  controller: passwordRegisterController,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 12,
                ),

                /// confirm password text
                Text(
                  "Confirm Password",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBtnColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                /// confirm password text field
                CustomAuthTextField(
                  controller: confirmPasswordRegisterController,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "Confirm Password",
                  isPasswordField: true,
                ),

                const SizedBox(
                  height: 38,
                ),

                /// register button
                CustomIconBtn(
                  btnHeight: 50,
                  btnWidth: 700,
                  btnColor: AppColors.primaryColor,
                  onTap: () {
                    emailAuthProvider.signUp(
                      context: context,
                      username: userNameRegisterController.text.trim(),
                      email: emailRegisterController.text.trim(),
                      password: passwordRegisterController.text.trim(),
                      confirmPassword:
                          confirmPasswordRegisterController.text.trim(),
                    );
                  },
                  btnWidget: emailAuthProvider.isLoading
                      ? CircularProgressIndicator(
                          color: AppColors.secondaryColor,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 22,
                              color: AppColors.secondaryColor,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed("loginScreen");
                    },
                    child: Text(
                      "Already have an account?",
                      style: GoogleFonts.poppins(
                        color: AppColors.textBtnColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
