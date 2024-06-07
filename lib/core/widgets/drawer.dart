import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/utils/alert_dialog.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/listtile_items_card.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/login/controller/auth_cubit.dart';
import 'package:remote_eye/features/login/models/user_model.dart';
import 'package:remote_eye/features/login/view/login_screen.dart';
import 'package:remote_eye/features/login/view/profile_screen.dart';
import 'package:remote_eye/features/login/view/register_screen.dart';
import 'package:remote_eye/features/login/view/users_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width / 1.5,
        backgroundColor: AppColors.optionalColor,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 50,
                      child: TextsWidget(
                        text: userModel.userName[0],
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextsWidget(
                  color: AppColors.primaryColor.withOpacity(0.8),
                  textAlign: TextAlign.center,
                  text: userModel.userName,
                  size: 18,
                ),
                const SizedBox(
                  height: 25,
                ),
                ItemsCard(
                  leadingIcon: Icons.manage_accounts_rounded,
                  title: "Update Profile",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(userModel: userModel),
                        ));
                  },
                ),
                userModel.isSuperAdmin
                    ? ItemsCard(
                        leadingIcon: Icons.group_add,
                        title: "Register new admin",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ));
                        },
                      )
                    : const SizedBox(),
                userModel.isSuperAdmin
                    ? ItemsCard(
                        leadingIcon: Icons.supervised_user_circle_sharp,
                        title: "Admins list",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UsersScreen(),
                              ));
                        },
                      )
                    : const SizedBox(),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onPressed: () {
                      DialogUtils.show(
                        context,
                        action: "Logout",
                        content: "Are you sure you want to Logout?",
                        onPressed: () {
                          BlocProvider.of<AuthCubit>(context).signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      );
                    },
                    icon: Icons.logout_rounded,
                    text: "Logout",
                    textAndIconColor: AppColors.redColor,
                    buttonColor: AppColors.optionalColor.withOpacity(0.5),
                  ),
                ))
              ],
            ),
          ),
        ));
  }
}
