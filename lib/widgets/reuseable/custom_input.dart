import 'package:flutter/material.dart';
import 'package:socially/utils/constants/colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String lableText;
  final IconData icon;
  final bool obsecureText;
  final String? Function(String?) validator;

  const CustomInput({
    super.key,
    required this.controller,
    required this.lableText,
    required this.icon,
    required this.obsecureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(8));
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: borderStyle,
        focusedBorder: borderStyle,
        enabledBorder: borderStyle,
        labelText: lableText,
        labelStyle: TextStyle(color: mainWhiteColor),
        filled: true,
        prefixIcon: Icon(
          icon,
          color: mainWhiteColor,
          size: 20,
        ),
      ),
      obscureText: obsecureText,
      validator: validator,
    );
  }
}
