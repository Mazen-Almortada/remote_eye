import 'package:remote_eye/features/detector/models/meta_data.dart';

class EventModel {
  final String eventKey;
  final List<MetaDataModel> metadataList;

  EventModel({
    required this.eventKey,
    required this.metadataList,
  });

  factory EventModel.fromMap(String key, Map<dynamic, dynamic> map) {
    List<MetaDataModel> metadataList = [];
    map.forEach((metadataKey, metadataValue) {
      if (map["additional_info"] == null) {
        metadataList.add(
            MetaDataModel.fromMap(Map<String, dynamic>.from(metadataValue)));
      } else {
        metadataList.add(MetaDataModel.fromMap(Map<String, dynamic>.from(map)));
      }
    });
    return EventModel(
      eventKey: key,
      metadataList: metadataList,
    );
  }
}
