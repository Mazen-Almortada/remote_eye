import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/loading_dialog.dart';
import 'package:remote_eye/core/utils/mediaquery.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/custom_text_form_field.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/staff/controller/cubit/staff_controller_cubit.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  File? image;

  Future<void> takePicture(ImageSource source) async {
    try {
      var pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
        await dedectFaces(File(pickedImage.path));
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Someting error");
    }
  }

  int _selectedValue = 0;
  TextEditingController staffNameController = TextEditingController(text: "");
  bool faceDetecated = false;
  dedectFaces(File img) async {
    final faceDetector = FaceDetector(options: FaceDetectorOptions());
    final inputImage = InputImage.fromFilePath(img.path);
    final faces = await faceDetector.processImage(inputImage);
    if (faces.isEmpty) {
      setState(() {
        faceDetecated = false;
      });
      Fluttertoast.showToast(msg: "no faces detecated in picture ");
    } else {
      setState(() {
        faceDetecated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTapLeading: () {
          Navigator.pop(context);
        },
        leadingIcon: Icons.arrow_back_ios,
        title: const TextsWidget(
          text: "Add new Staff",
          size: 20,
        ),
      ),
      body: BlocListener<StaffControllerCubit, StaffControllerState>(
        listener: (context, state) {
          if (state is StaffUploadSuccess) {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Staff added successfull!");
            setState(() {
              image = null;
              staffNameController.clear();
            });
          } else if (state is StaffUploadError) {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: state.errorMessage);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    takePicture(_selectedValue == 0
                        ? ImageSource.gallery
                        : ImageSource.camera);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.opcacityColor,
                    ),
                    width: kWidth(context),
                    height: 250,
                    child: image == null
                        ? const Icon(Icons.camera_alt_rounded)
                        : Image.file(image!),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: RadioListTile<int>(
                        visualDensity: VisualDensity.compact,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: TextsWidget(
                          text: "gallery",
                          style: AppTextStyle.secondaryTextStyle.copyWith(
                              color: AppColors.blackColor, fontSize: 13),
                        ),
                        value: 0,
                        activeColor: AppColors.secondaryColor,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<int>(
                        visualDensity: VisualDensity.compact,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: TextsWidget(
                          text: "camera",
                          style: AppTextStyle.secondaryTextStyle.copyWith(
                              color: AppColors.blackColor, fontSize: 13),
                        ),
                        value: 1,
                        activeColor: AppColors.secondaryColor,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  hintText: "Name",
                  controller: staffNameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(
                    disabled: !faceDetecated,
                    onPressed: () {
                      if (faceDetecated) {
                        final regex = RegExp(r'^\s*$');

                        if (!regex.hasMatch(staffNameController.text)) {
                          BlocProvider.of<StaffControllerCubit>(context)
                              .addStaff(staffNameController.text, image!);
                          LoadingDialogUtils.show(context);
                        } else {
                          Fluttertoast.showToast(msg: "the name is incorrect");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "no faces detecated in picture ");
                      }
                    },
                    text: "Add Staff",
                    buttonColor: faceDetecated
                        ? AppColors.secondaryColor
                        : AppColors.subTitleColor.withOpacity(0.5))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
