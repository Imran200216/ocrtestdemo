import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOCRTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final VoidCallback onSuffixIconPressed;
  final Color borderColor;
  final Color buttonColor;
  final TextEditingController? controller;

  const CustomOCRTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.onSuffixIconPressed,
    this.borderColor = const Color(0xFFB0BEC5),
    this.buttonColor = const Color(0xFF1E88E5),
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          color: borderColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: borderColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
            color: borderColor,
          ),
          onPressed: onSuffixIconPressed,
        ),
      ),
    );
  }
}
