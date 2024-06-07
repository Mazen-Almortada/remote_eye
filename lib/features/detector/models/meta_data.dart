class MetaDataModel {
  String? message;
  String? imageUrl;
  String? metadataTime;
  MetaDataModel({
    this.message,
    this.imageUrl,
    this.metadataTime,
  });

  factory MetaDataModel.fromMap(Map<String, dynamic> map) {
    return MetaDataModel(
      message: map['additional_info'] != null
          ? map['additional_info'] as String
          : "No additional info",
      imageUrl: map['image_url'] != null ? map['image_url'] as String : "",
      metadataTime: map['timestamp'] != null
          ? map['timestamp'] as String
          : DateTime.now().toString(),
    );
  }
}
