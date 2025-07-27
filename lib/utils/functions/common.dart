import 'package:flutter/material.dart';
import 'package:socially/utils/constants/colors.dart';

void showSnackBar({
  required String text,
  required BuildContext context,
  bool isWarn = false,
}) {
  final snackBgColor = isWarn ? mainOrangeColor : Colors.grey[900];
  final snackTextColor = isWarn ? Colors.black : Colors.white;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: snackBgColor,
      content: Text(
        text,
        style: TextStyle(color: snackTextColor),
      ),
    ),
  );
}
