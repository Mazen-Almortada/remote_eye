import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/date_formater.dart';
import 'package:remote_eye/core/utils/mediaquery.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/drawer.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/camera/camera_screen.dart';
import 'package:remote_eye/features/detector/controller/cubit/detector_cubit.dart';
import 'package:remote_eye/features/detector/views/detect_photos_screen.dart';
import 'package:remote_eye/features/home/controller/cubit/home_cubit.dart';
import 'package:remote_eye/features/login/models/user_model.dart';
import 'package:remote_eye/features/staff/view/add_staff.dart';
import 'package:remote_eye/features/staff/view/staffs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel user =
      UserModel(userName: " ", email: " ", password: " ", phoneNumber: "");
  getUserInfo() async {
    user = await BlocProvider.of<HomeCubit>(context).getCurrentUserInfo();
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.primaryColor2,
          extendBody: true,
          appBar: CustomAppBar(
            title: const TextsWidget(
              text: "Al Iman Center",
              size: 20,
            ),
            drawerBuilder: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu,
                      size: 25, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ),
          endDrawerEnableOpenDragGesture: true,
          endDrawer: CustomDrawer(userModel: user),
          body: Center(
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  TextsWidget(
                    text: "Detect People Photos",
                    size: 17,
                    style: AppTextStyle.secondaryTextStyle,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DetectorPhotosScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: kWidth(context) > 400 ? 400 : 250,
                      child: BlocBuilder<DetectorCubit, DetectorState>(
                        builder: (context, state) {
                          if (state is DetectNewEvents) {
                            if (state.eventModel != null &&
                                state.eventModel!.metadataList.isNotEmpty) {
                              var metadataModel =
                                  state.eventModel!.metadataList.first;
                              return Stack(
                                children: [
                                  CachedNetworkImage(
                                    width: kWidth(context),
                                    imageUrl: metadataModel.imageUrl!,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minHeight: 50,
                                        minWidth: kWidth(context),
                                      ),
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              end: Alignment.bottomCenter,
                                              begin: Alignment.topCenter,
                                              colors: [
                                            AppColors.subTitleColor
                                                .withOpacity(0.1),
                                            AppColors.subTitleColor
                                                .withOpacity(0.3),
                                            AppColors.blackColor
                                                .withOpacity(0.4),
                                            AppColors.blackColor
                                                .withOpacity(0.5),
                                            AppColors.blackColor
                                                .withOpacity(0.6),
                                            AppColors.blackColor
                                                .withOpacity(0.7),
                                            AppColors.blackColor
                                                .withOpacity(0.7),
                                            AppColors.blackColor
                                                .withOpacity(0.8),
                                            AppColors.blackColor
                                                .withOpacity(0.9),
                                            AppColors.blackColor
                                                .withOpacity(0.9)
                                          ])),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextsWidget(
                                          textAlign: TextAlign.left,
                                          text:
                                              "${metadataModel.message!} \n ${formatDate(metadataModel.metadataTime)} ${formatTime(metadataModel.metadataTime)}",
                                          style: AppTextStyle.thirdTextStyle,
                                          color: AppColors.primaryColor2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                          }
                          return Image.asset(
                            "assets/images/face.jpg",
                            fit: BoxFit.fitWidth,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      staffOptions(
                        "Remove Staff",
                        "assets/images/remove-staff.png",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StaffsScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: kWidth(context) > 400 ? 60 : 30,
                      ),
                      staffOptions(
                        "Add Staff",
                        "assets/images/add-staff.png",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddStaffScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 85,
                  )
                ],
              ),
            )),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: FloatingActionButton(
                  elevation: 0,
                  shape: const CircleBorder(
                      side: BorderSide(width: 5, color: AppColors.blackColor)),
                  backgroundColor: AppColors.primaryColor2,
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 30,
                    color: AppColors.blackColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(),
                        ));
                  })),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 2, color: AppColors.blackColor))),
            margin: const EdgeInsets.only(bottom: 25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TextsWidget(
                    text: "Track Real",
                    size: 17,
                  ),
                  TextsWidget(
                    text: "Time Video",
                    size: 17,
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget staffOptions(
    String text,
    String imagePath,
    void Function()? onTap,
  ) {
    return Expanded(
        child: Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 130,
            width: kWidth(context),
            color: AppColors.white,
            child: Image.asset(imagePath),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: InkWell(
              onTap: onTap,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: kWidth(context),
                  color: AppColors.white,
                  child: TextsWidget(
                    size: 15,
                    textAlign: TextAlign.center,
                    text: text,
                  ))),
        )
      ],
    ));
  }
}
