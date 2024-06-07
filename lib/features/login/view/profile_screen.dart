import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/utils/loading_dialog.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/custom_text_form_field.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/login/models/user_model.dart';

import '../controller/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({super.key, required this.userModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController passController = TextEditingController(text: "");
  TextEditingController newPassController = TextEditingController(text: "");
  TextEditingController confirmPassController = TextEditingController(text: "");
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          onTapLeading: () {
            Navigator.pop(context);
          },
          leadingIcon: Icons.arrow_back_ios,
          title: const TextsWidget(
            text: "Update User Credential",
            size: 20,
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is UpdateUserSuccess) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Credential updated successfull!");
            } else if (state is UpdateUserFailure) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: state.errorMessage);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "Name",
                        prefixIcon: Icons.account_circle,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Phone Number",
                        prefixIcon: Icons.phone,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Current Password",
                        prefixIcon: Icons.password,
                        controller: passController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "New Password",
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        controller: newPassController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Confirm Password",
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        controller: confirmPassController,
                      ),
                      const SizedBox(height: 35),
                      CustomButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (passController.text ==
                                  widget.userModel.password) {
                                if (newPassController.text ==
                                    confirmPassController.text) {
                                  UserModel userModel = widget.userModel
                                    ..phoneNumber = phoneController.text
                                    ..userName = nameController.text;
                                  BlocProvider.of<AuthCubit>(context)
                                      .updateUser(
                                          userModel, newPassController.text);
                                  LoadingDialogUtils.show(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Passwords do not match!");
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "The current password is incorrect");
                              }
                            } else {
                              autovalidateMode = AutovalidateMode.always;
                              setState(() {});
                            }
                          },
                          icon: Icons.manage_accounts_outlined,
                          text: "Update credential",
                          buttonColor: AppColors.secondaryColor.withOpacity(1),
                          textAndIconColor: AppColors.primaryColor),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
