import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOCRTextFieldWithBtn extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final VoidCallback onSuffixIconPressed;
  final VoidCallback onButtonPressed;
  final String buttonText;
  final Color borderColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final TextEditingController? controller;

  const CustomOCRTextFieldWithBtn({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.onSuffixIconPressed,
    required this.onButtonPressed,
    required this.buttonText,
    this.borderColor = const Color(0xFFB0BEC5),
    this.buttonColor = const Color(0xFF1E88E5),
    this.buttonTextColor = Colors.white,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
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
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: onButtonPressed,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: buttonColor,
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    color: buttonTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
