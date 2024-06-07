import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {required this.hintText,
      this.obscureText = false,
      this.prefixIcon,
      super.key,
      this.onSaved,
      this.controller,
      this.keyboardType});
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final bool obscureText;
  final String hintText;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: false,
        keyboardType: keyboardType,
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return "Field cannot be empty";
          } else {
            return null;
          }
        },
        textInputAction: TextInputAction.next,
        onTap: () {
          if (controller != null) {
            if (controller!.selection ==
                TextSelection.fromPosition(
                    TextPosition(offset: controller!.text.length - 1))) {
              controller!.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller!.text.length));
            }
          }
        },
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.subTitleColor,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: hintText,
          hintStyle: AppTextStyle.thirdTextStyle,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.subTitleColor)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
  }
}
