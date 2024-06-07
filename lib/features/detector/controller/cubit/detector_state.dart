// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detector_cubit.dart';

class DetectorState {}

class DetectorInitial extends DetectorState {}

class SaveDetectedPhotoLoading extends DetectorState {}

class SaveDetectedPhotoError extends DetectorState {}

class SaveDetectedPhotoSuccess extends DetectorState {
  String message;
  SaveDetectedPhotoSuccess({
    required this.message,
  });
}

class DetectNewEvents extends DetectorState {
  int eventCount;
  EventModel? eventModel;
  DetectNewEvents({required this.eventCount, this.eventModel});
}

class DownloadEventsLoading extends DetectorState {}

class DownloadEventsSuccess extends DetectorState {
  String saveSuccessMessage;
  DownloadEventsSuccess({
    required this.saveSuccessMessage,
  });
}

class DownloadEventsError extends DetectorState {
  String errorMessage;
  DownloadEventsError({
    required this.errorMessage,
  });
}
