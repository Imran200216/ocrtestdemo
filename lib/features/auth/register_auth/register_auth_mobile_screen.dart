import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocrtestdemo/commons/custom_auth_text_field.dart';
import 'package:ocrtestdemo/commons/custom_icon_btn.dart';
import 'package:ocrtestdemo/commons/custom_snack_bar.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterAuthMobileScreen extends StatelessWidget {
  const RegisterAuthMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;

    /// controllers
    TextEditingController userNameRegisterController = TextEditingController();
    TextEditingController emailRegisterController = TextEditingController();
    TextEditingController passwordRegisterController = TextEditingController();
    TextEditingController confirmPasswordRegisterController =
        TextEditingController();

    /// sign up user
    Future<void> signIn() async {
      try {
        // Make sure fields are not empty
        if (userNameRegisterController.text.isEmpty ||
            emailRegisterController.text.isEmpty ||
            passwordRegisterController.text.isEmpty ||
            confirmPasswordRegisterController.text.isEmpty) {
          CustomFailureSnackBar.showFailureAwesomeSnackBar(
            context: context,
            title: "Empty Fields",
            message: "Please fill in all fields.",
          );
          return;
        }

        if (passwordRegisterController.text !=
            confirmPasswordRegisterController.text) {
          CustomFailureSnackBar.showFailureAwesomeSnackBar(
            context: context,
            title: "Password Mismatch",
            message: "Passwords do not match.",
          );
          return;
        }

        // Make the Supabase call to sign up
        final response = await supabase.auth.signInWithPassword(
          password: passwordRegisterController.text.trim(),
          email: emailRegisterController.text.trim(),
        );

        print("Supabase SignUp Response: ${response}");

        // Check if the sign up was successful
        if (response.user == null) {
          throw Exception(response ?? "Unknown error occurred.");
        }

        CustomSuccessSnackBar.showSuccessAwesomeSnackBar(
          context: context,
          title: "Authentication Success",
          message: "Your authentication is successful!",
        );

        context.goNamed("homeScreen");

        return;
      } on AuthException catch (e) {
        print('AuthException: ${e.message}');
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: "Authentication Error",
          message: e.message ?? "Unknown error occurred.",
        );
      } catch (e) {
        print('Error: $e');
        CustomFailureSnackBar.showFailureAwesomeSnackBar(
          context: context,
          title: "Error",
          message: "An unexpected error occurred. Please try again.",
        );
      }
    }

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
                    signIn();
                  },
                  btnWidget: Row(
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
