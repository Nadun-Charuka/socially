import 'package:flutter/material.dart';
import 'package:socially/utils/constants/constants.dart';
import 'package:socially/views/responsive/mobile_layout.dart';
import 'package:socially/views/responsive/web_layout.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileLayout;
  final Widget webLayout;
  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.webLayout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webLayoutMinWidth) {
          return WebLayout();
        } else {
          return MobileLayout();
        }
      },
    );
  }
}
