import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/commons/custom_auth_text_field.dart';
import 'package:ocrtestdemo/commons/custom_icon_btn.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:ocrtestdemo/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginAuthDesktopScreen extends StatelessWidget {
  const LoginAuthDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// auth provider
    final emailAuthProvider = Provider.of<EmailAuthProvider>(context);

    /// text editing controllers
    final TextEditingController emailLoginController = TextEditingController();
    final TextEditingController passwordLoginController =
        TextEditingController();

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
          height: 600,
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
                  "Login In",
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

                /// email text filed
                CustomAuthTextField(
                  controller: emailLoginController,
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

                /// password text filed
                CustomAuthTextField(
                  controller: passwordLoginController,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed("forgetPasswordScreen");
                    },
                    child: Text(
                      "Forget password?",
                      style: GoogleFonts.poppins(
                        color: AppColors.textBtnColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 38,
                ),

                /// sign in btn
                CustomIconBtn(
                  btnHeight: 50,
                  btnWidth: 700,
                  btnColor: AppColors.primaryColor,
                  onTap: () {
                    emailAuthProvider.signIn(
                      context: context,
                      email: emailLoginController.text.trim(),
                      password: passwordLoginController.text.trim(),
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
                              Icons.login,
                              size: 22,
                              color: AppColors.secondaryColor,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Sign In",
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
                      context.pushNamed("registerScreen");
                    },
                    child: Text(
                      "Don't have an account?",
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
