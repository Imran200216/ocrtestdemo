import 'package:flutter/material.dart';
import 'package:ocrtestdemo/constants/colors.dart';

class CustomIconBtn extends StatelessWidget {
  final Widget btnWidget;
  final VoidCallback onTap;
  final double btnHeight;
  final double btnWidth;
  final Color btnColor;

  const CustomIconBtn({
    super.key,
    required this.btnWidget,
    required this.onTap,
    required this.btnHeight,
    required this.btnWidth,
    required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: btnColor,
        ),
        child: Center(
          child: btnWidget,
        ),
      ),
    );
  }
}
