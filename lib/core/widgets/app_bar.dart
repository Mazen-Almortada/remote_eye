import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);

  final IconData? leadingIcon;
  final Widget? title;
  final Color? backgroundColor;
  final Widget? drawerBuilder;
  final Function()? onTapLeading;

  const CustomAppBar(
      {super.key,
      this.title,
      this.drawerBuilder,
      this.leadingIcon,
      this.onTapLeading,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: title,
        centerTitle: true,
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: 0,
        leading: leadingIcon != null
            ? IconButton(
                icon: Icon(
                  leadingIcon,
                  color: AppColors.blackColor,
                  size: 25,
                ),
                onPressed: onTapLeading,
              )
            : null,
        actions: [drawerBuilder ?? const SizedBox()]);
  }
}
