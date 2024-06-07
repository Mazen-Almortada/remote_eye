import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/mediaquery.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';

class ConnectionErrorWidget extends StatelessWidget {
  final String text;
  final String? imagePath;

  const ConnectionErrorWidget({super.key, required this.text, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath ?? 'assets/images/error.png',
                  width: kWidth(context) * 0.70),
              const SizedBox(
                height: 30,
              ),
              TextsWidget(
                textAlign: TextAlign.center,
                text: text,
                style: AppTextStyle.thirdTextStyle,
                size: 15,
                color: AppColors.redColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
