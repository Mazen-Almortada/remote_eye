import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/controller/cubit/app_controller_cubit.dart';

import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/login/view/login_screen.dart';

import '../models/onboarding_class.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          contents[i].image,
                          fit: BoxFit.contain,
                          height: 220,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextsWidget(
                          text: contents[i].title,
                          size: 20,
                          color: AppColors.blackColor,
                        ),
                        currentIndex != 0
                            ? const SizedBox(height: 40)
                            : const SizedBox(height: 60),
                        TextsWidget(
                            text: contents[i].discription,
                            textAlign: TextAlign.center,
                            bold: false,
                            size: 17,
                            style: AppTextStyle.secondaryTextStyle),
                        currentIndex == 0
                            ? GestureDetector(
                                onTap: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: AppColors.secondaryColor),
                                      borderRadius: BorderRadius.circular(50)),
                                  height: 70,
                                  width: 70,
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 30,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          currentIndex != 0
              ? CustomButton(
                  margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                  onPressed: () async {
                    if (currentIndex == contents.length - 1) {
                      BlocProvider.of<AppControllerCubit>(context)
                          .setFirstTimeValue(false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    }
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                  text: currentIndex == contents.length - 1
                      ? "Get Started"
                      : "Next",
                  buttonColor: AppColors.secondaryColor)
              : const SizedBox()
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.secondaryColor,
      ),
    );
  }
}
