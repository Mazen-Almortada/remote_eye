import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/loading_dialog.dart';
import 'package:remote_eye/core/utils/mediaquery.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/custom_text_form_field.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/login/controller/auth_cubit.dart';
import 'package:remote_eye/features/home/view/home_screen.dart';
import 'package:remote_eye/features/login/view/forgot_password_screen.dart';
import 'package:remote_eye/features/login/widgets/background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = kHeight(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Login successfull!");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        } else if (state is LoginFailure) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: state.errorMessage);
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            child: Background(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height <= 650 ? 120 : 140,
                  ),
                  Center(
                    child: SizedBox(
                      height: kScreensHeight(height),
                      width: kScreensHeight(height),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: height <= 640 ? 70 : 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                    child: Form(
                        key: _formKey,
                        autovalidateMode: autovalidateMode,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
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
                            CustomTextFormField(
                              controller: passwordController,
                              obscureText: true,
                              onSaved: (value) {
                                passwordController.text = value!;
                              },
                              hintText: "Password",
                              prefixIcon: Icons.password,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  )),
                              child: Container(
                                padding: const EdgeInsets.only(left: 5),
                                alignment: Alignment.centerLeft,
                                child: TextsWidget(
                                  text: "Forgot Password?",
                                  size: 13,
                                  color: AppColors.optionalColor,
                                  style: AppTextStyle.thirdTextStyle,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            CustomButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    context.read<AuthCubit>().login(
                                        emailController.text,
                                        passwordController.text);
                                    LoadingDialogUtils.show(context);
                                  } else {
                                    autovalidateMode = AutovalidateMode.always;
                                    setState(() {});
                                  }
                                },
                                icon: Icons.login,
                                text: "Login",
                                textAndIconColor: AppColors.primaryColor,
                                buttonColor: AppColors.secondaryColor),
                          ],
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
