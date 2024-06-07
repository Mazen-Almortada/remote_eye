import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/loading_dialog.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/custom_text_form_field.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/login/controller/auth_cubit.dart';
import 'package:remote_eye/features/login/widgets/background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  TextEditingController emailController = TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RestPasswordLinkSent) {
          const String passwordRestLinkMessage =
              "Check your email \nWe've sent password rest link to your email.";

          Navigator.pop(context);
          Fluttertoast.showToast(msg: passwordRestLinkMessage);
          Navigator.pop(context);
        } else if (state is RestPasswordLinkFailure) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: state.errorMessage);
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            child: Background(
              child: Form(
                  key: _formKey,
                  autovalidateMode: autovalidateMode,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextsWidget(
                          text:
                              "Enter the email address associated with your account and we'll send you a link to rest your password.",
                          size: 15,
                          style: AppTextStyle.thirdTextStyle,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        CustomTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          hintText: "Email",
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                context.read<AuthCubit>().sendRestPasswordLink(
                                      emailController.text,
                                    );
                                LoadingDialogUtils.show(context);
                              } else {
                                autovalidateMode = AutovalidateMode.always;
                                setState(() {});
                              }
                            },
                            icon: Icons.send,
                            text: "Send",
                            textAndIconColor: AppColors.primaryColor,
                            buttonColor: AppColors.secondaryColor)
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}
