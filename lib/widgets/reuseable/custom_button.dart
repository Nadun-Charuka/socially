import 'package:flutter/material.dart';
import 'package:socially/utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;
  const CustomButton(
      {super.key,
      required this.text,
      required this.width,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: customGradientColor,
          borderRadius: BorderRadius.circular(8)),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: mainWhiteColor,
          ),
        ),
      ),
    );
  }
}
