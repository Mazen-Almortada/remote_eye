import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/utils/mediaquery.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {required this.onPressed,
      this.icon,
      required this.text,
      this.textAndIconColor,
      required this.buttonColor,
      super.key,
      this.margin,
      this.disabled = false,
      this.textSize,
      this.buttonHeight,
      this.buttonWidth});
  final void Function()? onPressed;
  final bool disabled;
  final Color buttonColor;
  final String text;
  final Color? textAndIconColor;
  final IconData? icon;
  final EdgeInsetsGeometry? margin;
  final double? textSize;
  final double? buttonHeight;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: buttonWidth ?? MediaQuery.of(context).size.width,
        highlightElevation: disabled ? 0 : null,
        splashColor: disabled ? Colors.transparent : null,
        highlightColor: disabled ? Colors.transparent : null,
        color: buttonColor,
        elevation: disabled ? 0 : 2,
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: buttonColor),
            borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: buttonWidth ?? MediaQuery.of(context).size.width,
          height: buttonHeight ?? 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextsWidget(
                  text: text,
                  color: textAndIconColor ?? AppColors.primaryColor,
                  size: textSize ?? (kWidth(context) <= 300 ? 13 : 17)),
              icon != null
                  ? Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          icon,
                          color: textAndIconColor,
                          size: kWidth(context) <= 300 ? 20 : 23,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
