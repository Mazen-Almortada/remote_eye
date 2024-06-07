import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';

import '../../../core/widgets/texts_widget.dart';

class DatePickerField extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final String? hintText;
  final EdgeInsets? padding;

  const DatePickerField(
      {Key? key, this.text, this.onTap, this.hintText, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextsWidget(text: text ?? "", style: AppTextStyle.secondaryTextStyle),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: IgnorePointer(
              child: TextFormField(
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.opcacityColor,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: hintText,
                    hintStyle: AppTextStyle.secondaryTextStyle
                        .copyWith(color: AppColors.blackColor),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide:
                          BorderSide(width: 2.0, color: AppColors.primaryColor),
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.blackColor,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
