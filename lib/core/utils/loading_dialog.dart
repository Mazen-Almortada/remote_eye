import 'package:flutter/material.dart';
import 'package:remote_eye/core/widgets/blur_background_ui.dart';
import 'package:remote_eye/core/widgets/loading_widget.dart';

class LoadingDialogUtils {
  static Future<void> show(BuildContext context, [Widget? child]) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: BlurBackground(
            child: child ?? const LoadingWidget(),
          ),
        );
      },
    );
  }
}
