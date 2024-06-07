import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/widgets/blur_background_ui.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';

class DialogUtils {
  static Future<void> show(BuildContext context,
      {required String content,
      required String action,
      required void Function()? onPressed}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlurBackground(
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentTextStyle: AppTextStyle.thirdTextStyle
                .copyWith(fontSize: 18, color: AppColors.blackColor),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: const TextsWidget(size: 19, text: 'Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: onPressed,
                child: TextsWidget(
                  text: action,
                  size: 19,
                  color: AppColors.redColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
