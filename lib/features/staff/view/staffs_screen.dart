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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:remote_eye/features/staff/controller/cubit/staff_controller_cubit.dart';
import 'package:remote_eye/features/staff/models/staff_model.dart';

class StaffsScreen extends StatefulWidget {
  const StaffsScreen({super.key});

  @override
  State<StaffsScreen> createState() => _StaffsScreenState();
}

class _StaffsScreenState extends State<StaffsScreen> {
  @override
  void initState() {
    BlocProvider.of<StaffControllerCubit>(context).fetchStaff();
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
          text: "Remove Staff",
          size: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: BlocConsumer<StaffControllerCubit, StaffControllerState>(
          listener: (context, state) {
            if (state is DeleteStaffError) {
              Fluttertoast.showToast(msg: state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is FetchStaffLoading) {
              return const LoadingWidget();
            } else if (state is FetchStaffError) {
              return ConnectionErrorWidget(text: state.errorMessage);
            } else if (state is FetchStaffEmpty) {
              return const ConnectionErrorWidget(
                text: "No staff members found.",
                imagePath: 'assets/images/nodata.webp',
              );
            } else if (state is FetchStaffSuccess) {
              return ListView.builder(
                itemCount: state.staffList.length,
                itemBuilder: (context, index) {
                  var staff = state.staffList[index];
                  return staffTile(staff);
                },
              );
            }
            return const Center();
          },
        ),
      ),
    );
  }

  Widget staffTile(StaffModel staff) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: ListTile(
        tileColor: AppColors.opcacityColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
        leading: ClipOval(
          child: CachedNetworkImage(
            imageUrl: staff.imagePath!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: TextsWidget(
            text: staff.fullName,
            style: AppTextStyle.secondaryTextStyle,
            color: AppColors.blackColor,
            size: 15),
        trailing: IconButton(
          onPressed: () {
            DialogUtils.show(
              context,
              action: "Delete",
              content: "Are you sure you want to delete staff?",
              onPressed: () async {
                BlocProvider.of<StaffControllerCubit>(context)
                    .deleteStaff(staff);
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
