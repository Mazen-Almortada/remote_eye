import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';

class TextsWidget extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final bool bold;
  final TextAlign? textAlign;
  final TextStyle? style;
  final TextDirection? textDirection;
  const TextsWidget(
      {required this.text,
      this.style,
      this.size,
      this.color,
      this.bold = true,
      super.key,
      this.textDirection,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        softWrap: true,
        textAlign: textAlign ?? TextAlign.left,
        textDirection: textDirection,
        style: style != null
            ? style!.copyWith(
                color: color ?? AppColors.blackColor,
                fontSize: size ?? 13,
                fontWeight: bold ? FontWeight.bold : null)
            : AppTextStyle.primaryTextStyle.copyWith(
                color: color ?? AppColors.blackColor,
                fontSize: size ?? 13,
                fontWeight: bold ? FontWeight.bold : null));
  }
}
