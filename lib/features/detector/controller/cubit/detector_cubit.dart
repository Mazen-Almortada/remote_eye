import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remote_eye/core/services/database/database_provider.dart';
import 'package:remote_eye/core/services/database/hive/hive_strings.dart';
import 'package:http/http.dart' as http;
import 'package:remote_eye/core/services/local_storage_saver.dart';
import 'package:remote_eye/core/services/pdf_service.dart';
import 'package:remote_eye/features/detector/models/event_model.dart';
part 'detector_state.dart';

class DetectorCubit extends Cubit<DetectorState> {
  DetectorCubit() : super(DetectorInitial());
  DatabaseProvider databaseProvider = DatabaseProvider();
  DatabaseReference? lastEventCounterRef =
      FirebaseDatabase.instance.ref('last_event_counter');
  Future<void> checkUpdatedInEvents() async {
    DatabaseReference detectionsRef =
        FirebaseDatabase.instance.ref("detections");
    lastEventCounterRef?.onValue.listen((DatabaseEvent event) async {
      final int? counter = event.snapshot.value as int?;
      if (counter != null) {
        final lastCounter =
            databaseProvider.getAt(settingsBox, lastCounterEvent) as int?;
        if (lastCounter != null) {
          if (lastCounter < counter) {
            late EventModel firstEvent;

            try {
              DatabaseEvent detections = await detectionsRef.once();
              if (detections.snapshot.exists &&
                  detections.snapshot.value != null) {
                List<EventModel> events =
                    getEventsFromSnapshot(detections.snapshot.value as Map);

                firstEvent = events.first;
              }
            } catch (_) {}
            int eventsCount = counter - lastCounter;
            databaseProvider.putAt(true, settingsBox, receivedNewEvent);
            emit(DetectNewEvents(
                eventCount: eventsCount, eventModel: firstEvent));
          }
        } else {
          databaseProvider.putAt(counter, settingsBox, lastCounterEvent);
        }
      }
    });
  }

  void setEventUpdateCount(int eventsCount) async {
    final receiveEvent =
        databaseProvider.getAt(settingsBox, receivedNewEvent) as bool? ?? false;
    final lastCounter =
        databaseProvider.getAt(settingsBox, lastCounterEvent) as int? ?? 0;

    if (receiveEvent) {
      databaseProvider.putAt(
          eventsCount + lastCounter, settingsBox, lastCounterEvent);
      databaseProvider.putAt(false, settingsBox, receivedNewEvent);

      emit(DetectorInitial());
    }
  }

  void saveImageToLocal(String imageUrl) async {
    if (await Permission.storage.isGranted) {
      emit(SaveDetectedPhotoLoading());
      try {
        final response = await http.get(Uri.parse(imageUrl));
        final savedImagePath =
            await LocalStorageSaver.saveImage(response.bodyBytes);

        emit(SaveDetectedPhotoSuccess(
            message: "Image saved in $savedImagePath"));
      } catch (_) {
        emit(SaveDetectedPhotoError());
      }
    } else {
      await Permission.storage.request();
    }
  }

  Future<void> downloadEvents(DateTime startDate, DateTime endDate) async {
    String errorMessage = "Error when retrieve data from database";

    emit(DownloadEventsLoading());
    DatabaseReference ref = FirebaseDatabase.instance.ref("detections");
    try {
      DatabaseEvent detections = await ref.once();
      if (detections.snapshot.exists && detections.snapshot.value != null) {
        List<EventModel> events =
            getEventsFromSnapshot(detections.snapshot.value as Map);

        final eventsMetadataList = events
            .expand((event) => event.metadataList.where((metadata) {
                  DateTime metadataDate =
                      DateTime.parse(metadata.metadataTime!);
                  return metadataDate.isAfter(startDate) &&
                      metadataDate
                          .isBefore(endDate.add(const Duration(days: 1)));
                }).toList())
            .toList();

        if (eventsMetadataList.isNotEmpty) {
          final pdfFileBytes = await PdfService.createPdf(eventsMetadataList);
          final savedFilePath = await LocalStorageSaver.savePdf(pdfFileBytes);

          emit(DownloadEventsSuccess(
              saveSuccessMessage: "Events file saved in $savedFilePath"));
        } else {
          emit(DownloadEventsError(
              errorMessage:
                  "No events were found that occurred between these dates"));
        }
      } else {
        emit(DownloadEventsError(errorMessage: errorMessage));
      }
    } on FirebaseException catch (e) {
      emit(DownloadEventsError(errorMessage: e.message ?? errorMessage));
    } catch (e) {
      emit(DownloadEventsError(errorMessage: "'Failed to create pdf file'"));
    }
  }

  List<EventModel> getEventsFromSnapshot(Map snapshot) {
    Map<dynamic, dynamic> detections = Map<dynamic, dynamic>.from(snapshot);

    List<EventModel> events = detections.entries.map((entry) {
      return EventModel.fromMap(
          entry.key, Map<dynamic, dynamic>.from(entry.value["metadata"]));
    }).toList();
    events.sort((a, b) {
      DateTime earliestA = a.metadataList
          .map((meta) => DateTime.parse(meta.metadataTime!))
          .reduce((a, b) => a.isBefore(b) ? a : b);
      DateTime earliestB = b.metadataList
          .map((meta) => DateTime.parse(meta.metadataTime!))
          .reduce((a, b) => a.isBefore(b) ? a : b);

      return earliestB.compareTo(earliestA);
    });

    return events;
  }
}
