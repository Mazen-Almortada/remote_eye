import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/connection_error_widget.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isLoading = true;

  WebViewController webViewController = WebViewController()
    ..setBackgroundColor(const Color(0x00000000));
  bool connectionError = false;
  luanchStreamUrl() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("camera_url");
    DatabaseEvent cameraUrl = await ref.once();
    if (cameraUrl.snapshot.exists &&
        cameraUrl.snapshot.value != null &&
        cameraUrl.snapshot.value.toString().startsWith("http")) {
      int progressValue = 0;
      WebViewController newWebViewController = WebViewController()
        ..loadRequest(Uri.parse(cameraUrl.snapshot.value.toString().trim()))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              progressValue = progress;
            },
            onWebResourceError: (error) {
              setState(() {
                connectionError = true;
              });
            },
          ),
        )
        ..enableZoom(true);
      await Future<void>.delayed(
          const Duration(seconds: 8),
          () => progressValue > 50
              ? setState(() {
                  webViewController = newWebViewController;
                  isLoading = false;
                })
              : setState(() {
                  connectionError = true;
                }));
    } else {
      setState(() {
        connectionError = true;
      });
    }
  }

  @override
  void initState() {
    luanchStreamUrl();
    super.initState();
  }

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
          child: connectionError
              ? const SingleChildScrollView(
                  child: ConnectionErrorWidget(
                      text: "Error occurred while connecting to camera"))
              : isLoading
                  ? const CircularProgressIndicator(
                      color: AppColors.secondaryColor,
                    )
                  : WebViewWidget(
                      // ignore: prefer_collection_literals
                      gestureRecognizers: Set()
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                      controller: webViewController)),
    );
  }
}
