import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';

class ItemsCard extends StatelessWidget {
  const ItemsCard(
      {this.radius,
      super.key,
      this.onTap,
      required this.leadingIcon,
      required this.title,
      this.color});

  final double? radius;
  final IconData leadingIcon;
  final String title;
  final Color? color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 8)),
        color: AppColors.secondaryColor.withOpacity(0),
        child: ListTile(
            onTap: onTap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 8)),
            leading: Icon(
              leadingIcon,
              size: 30,
              color: color ?? AppColors.primaryColor.withOpacity(0.8),
            ),
            title: TextsWidget(
              text: title,
              size: 15,
              style: AppTextStyle.secondaryTextStyle,
              color: color ?? AppColors.primaryColor.withOpacity(0.8),
            )));
  }
}
