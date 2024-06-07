import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:remote_eye/core/style/app_colors.dart';

class BlurBackground extends StatelessWidget {
  const BlurBackground({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 8,
              color: AppColors.secondaryColor.withOpacity(0.3),
              spreadRadius: 5,
              offset: const Offset(0, 3)),
        ],
      ),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: child),
    );
  }
}
