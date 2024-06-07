import 'package:flutter/material.dart';

double kHeight(context) {
  return MediaQuery.of(context).size.height;
}

double kWidth(context) {
  return MediaQuery.of(context).size.width;
}

double kScreensHeight(double height) {
  if (height <= 300) {
    return 90;
  } else if (height <= 400) {
    return 100;
  } else if (height <= 500) {
    return 120;
  } else if (height <= 600) {
    return 140;
  } else if (height <= 800) {
    return 150;
  } else {
    return 170;
  }
}
