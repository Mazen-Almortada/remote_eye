import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/utils/date_formater.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/custom_button.dart';
import 'package:remote_eye/core/widgets/loading_widget.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/detector/controller/cubit/detector_cubit.dart';
import 'package:remote_eye/features/detector/widgets/date_picker.dart';

class DownloadEventsScreen extends StatefulWidget {
  const DownloadEventsScreen({super.key});

  @override
  State<DownloadEventsScreen> createState() => _DownloadEventsScreenState();
}

class _DownloadEventsScreenState extends State<DownloadEventsScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 1));

  void _selectDate(
      {required BuildContext context, required String fromDateOrToDate}) async {
    if (fromDateOrToDate == "fromDate") {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      setState(() {
        fromDate = picked ?? fromDate;
      });
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      setState(() {
        toDate = picked ?? toDate;
      });
    }
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
            text: "Download Events",
            size: 20,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: BlocConsumer<DetectorCubit, DetectorState>(
            listener: (context, state) {
              if (state is DownloadEventsError) {
                Fluttertoast.showToast(msg: state.errorMessage);
              } else if (state is DownloadEventsSuccess) {
                Fluttertoast.showToast(msg: state.saveSuccessMessage);
              }
            },
            builder: (context, state) {
              if (state is DownloadEventsLoading) {
                return const LoadingWidget();
              }
              return Column(
                children: [
                  DatePickerField(
                    text: "From Date",
                    onTap: () => _selectDate(
                        context: context, fromDateOrToDate: "fromDate"),
                    hintText: formatDate(fromDate),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DatePickerField(
                    text: "To Date",
                    onTap: () => _selectDate(
                        context: context, fromDateOrToDate: "toDate"),
                    hintText: formatDate(toDate),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomButton(
                      onPressed: () {
                        BlocProvider.of<DetectorCubit>(context)
                            .downloadEvents(fromDate, toDate);
                      },
                      text: "Download to Pdf",
                      textAndIconColor: AppColors.primaryColor,
                      buttonColor: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          )),
        ));
  }
}
