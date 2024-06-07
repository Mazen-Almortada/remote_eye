import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/custom_text_form_field.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController urlController = TextEditingController(text: "");
  bool isLoading = false;
  WebViewController webViewController = WebViewController()
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void dispose() {
    webViewController.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AppColors.primaryColor,
        onTapLeading: () {
          Navigator.pop(context);
        },
        leadingIcon: Icons.arrow_back_ios,
        title: const TextsWidget(
          text: "Camera Screen",
          size: 20,
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                      color: AppColors.opcacityColor,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 3, color: AppColors.optionalColor)),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondaryColor,
                          ),
                        )
                      : WebViewWidget(
                          // ignore: prefer_collection_literals
                          gestureRecognizers: Set()
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer())),
                          controller: webViewController)),
              const SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                  hintText: "Enter camera url", controller: urlController),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                  onPressed: () {
                    final regex = RegExp(r'^\s*$');

                    if (!regex.hasMatch(urlController.text)) {
                      String pattern =
                          r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
                      RegExp regExpUrl = RegExp(pattern);
                      if (!regExpUrl.hasMatch(urlController.text)) {
                        Fluttertoast.showToast(msg: 'Please enter valid url');
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        WebViewController newWebViewController =
                            WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..setNavigationDelegate(
                                NavigationDelegate(
                                  onPageFinished: (_) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                ),
                              )
                              ..loadRequest(Uri.parse(urlController.text))
                              ..enableZoom(true);
                        setState(() {
                          webViewController = newWebViewController;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Field cannot be empty");
                    }
                  },
                  text: "Connect",
                  buttonColor: AppColors.secondaryColor)
            ],
          ),
        ),
      )),
    );
  }
}
