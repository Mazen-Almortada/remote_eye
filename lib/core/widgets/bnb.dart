import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';

typedef OnIconTap = void Function(int index);

// ignore: must_be_immutable
class CustomBNB extends StatefulWidget {
  CustomBNB(
      {super.key,
      required this.items,
      this.onIconTapped,
      required this.currentIndex});
  final List<BNBItem> items;
  final OnIconTap? onIconTapped;
  int currentIndex;

  @override
  State<CustomBNB> createState() => _CustomBNBState();
}

class _CustomBNBState extends State<CustomBNB> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
          color: AppColors.optionalColor,
          borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...List.generate(
              widget.items.length,
              (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.currentIndex = index;
                    });

                    widget.onIconTapped!(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.items[index].icon,
                        color: widget.currentIndex == index
                            ? AppColors.primaryColor
                            : AppColors.subTitleColor,
                        size: widget.currentIndex == index ? 28 : 25,
                      ),
                      Text(
                        widget.items[index].content,
                        style: AppTextStyle.primaryTextStyle.copyWith(
                            color: widget.currentIndex == index
                                ? AppColors.primaryColor
                                : AppColors.subTitleColor,
                            fontSize: widget.currentIndex == index ? 11 : 9),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}

class BNBItem {
  final IconData icon;
  final String content;
  const BNBItem({
    required this.icon,
    required this.content,
  });
}
