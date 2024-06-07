import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/alert_dialog.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/connection_error_widget.dart';
import 'package:remote_eye/core/widgets/loading_widget.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/login/controller/auth_cubit.dart';
import 'package:remote_eye/features/login/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    BlocProvider.of<AuthCubit>(context).fetchUsers();
    super.initState();
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
          text: "Admins List",
          size: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is DeleteUserFailure) {
              Fluttertoast.showToast(msg: state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is FetchUsersLoading) {
              return const LoadingWidget();
            } else if (state is FetchUsersFailure) {
              if (state.errorMessage == "empty") {
                return const ConnectionErrorWidget(
                  text: "No admins users found.",
                  imagePath: 'assets/images/nodata.webp',
                );
              }
              return ConnectionErrorWidget(text: state.errorMessage);
            } else if (state is FetchUsersSuccess) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  var user = state.users[index];
                  return userTile(user);
                },
              );
            }
            return const Center();
          },
        ),
      ),
    );
  }

  Widget userTile(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        tileColor: AppColors.opcacityColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        title: TextsWidget(
            text: user.userName,
            style: AppTextStyle.primaryTextStyle,
            color: AppColors.blackColor,
            size: 15),
        subtitle: TextsWidget(
            text: user.email,
            style: AppTextStyle.thirdTextStyle,
            color: AppColors.subTitleColor,
            size: 12),
        trailing: IconButton(
          onPressed: () {
            DialogUtils.show(
              context,
              action: "Delete",
              content: "Are you sure you want to delete Admin?",
              onPressed: () async {
                BlocProvider.of<AuthCubit>(context).deleteUser(user);
                Navigator.pop(context);
              },
            );
          },
          icon: const Icon(
            Icons.delete_outline,
            color: AppColors.redColor,
          ),
        ),
      ),
    );
  }
}
