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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController passController = TextEditingController(text: "");
  TextEditingController phoneNumberController = TextEditingController(text: "");
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
            text: "Register new Admin",
            size: 20,
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is CreateAccountSuccess) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Account created successfull!");
            } else if (state is CreateAccountError) {
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
                        hintText: "Username",
                        prefixIcon: Icons.account_circle,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Email",
                        prefixIcon: Icons.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Phone Number",
                        prefixIcon: Icons.phone,
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Password",
                        prefixIcon: Icons.password,
                        obscureText: true,
                        controller: passController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hintText: "Confirm Password",
                        prefixIcon: Icons.password,
                        obscureText: true,
                        controller: confirmPassController,
                      ),
                      const SizedBox(height: 35),
                      CustomButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              if (passController.text ==
                                  confirmPassController.text) {
                                UserModel userModel = UserModel(
                                  email: emailController.text,
                                  password: passController.text,
                                  phoneNumber: phoneNumberController.text,
                                  userName: nameController.text,
                                );
                                BlocProvider.of<AuthCubit>(context)
                                    .signUp(userModel);

                                LoadingDialogUtils.show(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Passwords do not match!");
                              }
                            } else {
                              autovalidateMode = AutovalidateMode.always;
                              setState(() {});
                            }
                          },
                          icon: Icons.save,
                          text: "Create Account",
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
