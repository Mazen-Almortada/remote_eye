import 'package:flutter/material.dart';
import 'package:remote_eye/core/utils/mediaquery.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.width});
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/wait-image-unscreen.gif',
        width: width ?? kWidth(context) * 0.70,
      ),
    );
  }
}
