import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAuthTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPasswordField;
  final TextInputType keyboardType; // Specifies the type of keyboard

  const CustomAuthTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPasswordField = false,
    required this.keyboardType, // Make keyboardType required
  });

  @override
  State<CustomAuthTextField> createState() => _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends State<CustomAuthTextField> {
  bool _isObscured = true; // Controls visibility for password field

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      // Correctly use the passed keyboard type
      controller: widget.controller,
      obscureText: widget.isPasswordField ? _isObscured : false,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 12,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF787878),
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Color(0xFF575757),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Color(0xFF575757),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Color(0xFF575757),
            width: 1,
          ),
        ),
        fillColor: Colors.transparent,
        filled: false,
        suffixIcon: widget.isPasswordField
            ? IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF575757),
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        )
            : null,
      ),
    );
  }
}