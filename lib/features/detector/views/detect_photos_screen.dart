// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/core/style/app_text_style.dart';
import 'package:remote_eye/core/utils/alert_dialog.dart';
import 'package:remote_eye/core/utils/date_formater.dart';
import 'package:remote_eye/core/widgets/app_bar.dart';
import 'package:remote_eye/core/widgets/connection_error_widget.dart';
import 'package:remote_eye/core/widgets/loading_widget.dart';
import 'package:remote_eye/core/widgets/texts_widget.dart';
import 'package:remote_eye/features/detector/controller/cubit/detector_cubit.dart';
import 'package:remote_eye/features/detector/models/event_model.dart';
import 'package:remote_eye/features/detector/views/download_events_screen.dart';

class DetectorPhotosScreen extends StatefulWidget {
  const DetectorPhotosScreen({super.key});

  @override
  State<DetectorPhotosScreen> createState() => _DetectorPhotosScreenState();
}

class _DetectorPhotosScreenState extends State<DetectorPhotosScreen> {
  DatabaseReference detectionsRef = FirebaseDatabase.instance.ref('detections');
  bool _isTimedOut = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to trigger the timeout
    _startTimeout();
  }

  void _startTimeout() {
    _timer = Timer(const Duration(seconds: 20), () {
      setState(() {
        _isTimedOut = true;
      });
    });
  }

  void _cancelTimeout() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  void dispose() {
    _cancelTimeout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          backgroundColor: AppColors.primaryColor,
          drawerBuilder: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DownloadEventsScreen(),
                    ));
              },
              icon: const Icon(
                Icons.download_sharp,
                color: AppColors.blackColor,
              )),
          onTapLeading: () {
            Navigator.pop(context);
          },
          leadingIcon: Icons.arrow_back_ios,
          title: const TextsWidget(
            text: "Detected People Photos",
            size: 20,
          ),
        ),
        body: _isTimedOut
            ? const Center(
                child: SingleChildScrollView(
                  child: ConnectionErrorWidget(
                      text:
                          "Connection timed out. Please check your internet connection."),
                ),
              )
            : StreamBuilder(
                stream: detectionsRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData &&
                      !snapshot.hasError &&
                      snapshot.data?.snapshot.value != null) {
                    _cancelTimeout();

                    try {
                      List<EventModel> events =
                          BlocProvider.of<DetectorCubit>(context)
                              .getEventsFromSnapshot(
                                  snapshot.data?.snapshot.value as Map);

                      return BlocConsumer<DetectorCubit, DetectorState>(
                        listener: (context, state) {
                          if (state is SaveDetectedPhotoLoading) {
                            Fluttertoast.showToast(
                                msg: "Downloading the image.....");
                          } else if (state is SaveDetectedPhotoError) {
                            Fluttertoast.showToast(
                                msg: "A problem occurred while saving image");
                          }
                          if (state is SaveDetectedPhotoSuccess) {
                            Fluttertoast.showToast(msg: state.message);
                          }
                        },
                        builder: (context, state) {
                          int eventCount =
                              (state is DetectNewEvents) ? state.eventCount : 0;

                          return ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              bool isHighlighted = index < eventCount;
                              var event = events[index];
                              return eventTile(
                                  event, isHighlighted, eventCount);
                            },
                          );
                        },
                      );
                    } catch (_) {
                      return const Center(
                        child: SingleChildScrollView(
                          child: ConnectionErrorWidget(
                              text: "Error when retrieve data from database"),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: SingleChildScrollView(
                        child: LoadingWidget(),
                      ),
                    );
                  }
                },
              ));
  }

  Widget eventTile(EventModel eventModel, bool isHighlighted, int eventCount) {
    final tableTitles = ["Image", "Alert", "Date", "Time"];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.opcacityColor,
      ),
      child: GestureDetector(
        child: ExpansionTile(
          onExpansionChanged: (value) {
            BlocProvider.of<DetectorCubit>(context)
                .setEventUpdateCount(eventCount);
          },
          collapsedIconColor: AppColors.blackColor,
          iconColor: AppColors.redColor,
          tilePadding: const EdgeInsets.only(
            right: 15,
            left: 15,
          ),
          childrenPadding: const EdgeInsets.only(left: 15),
          title: TextsWidget(
              text: eventModel.eventKey,
              style: AppTextStyle.secondaryTextStyle,
              color: isHighlighted ? AppColors.redColor : AppColors.blackColor,
              size: 15),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(width: 1),
                children: [
                  TableRow(children: [
                    ...tableTitles.map((title) => Padding(
                          padding: const EdgeInsets.all(
                            3,
                          ),
                          child: TextsWidget(
                              text: title,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.primaryTextStyle,
                              color: AppColors.subTitleColor,
                              size: 12),
                        ))
                  ]),
                  ...eventModel.metadataList.map((metadata) {
                    return TableRow(children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            DialogUtils.show(
                              context,
                              action: "Save",
                              content: "Save image to local storage?",
                              onPressed: () async {
                                BlocProvider.of<DetectorCubit>(context)
                                    .saveImageToLocal("${metadata.imageUrl}");
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: metadata.imageUrl!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      cellContent(metadata.message!),
                      cellContent(formatDate(metadata.metadataTime)),
                      cellContent(formatTime(metadata.metadataTime)!),
                    ]);
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cellContent(String text) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: TextsWidget(
          textAlign: TextAlign.center,
          text: text,
          style: AppTextStyle.primaryTextStyle,
          color: AppColors.blackColor,
          size: 11),
    );
  }
}
