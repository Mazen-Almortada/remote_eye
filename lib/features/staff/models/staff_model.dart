// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: import_of_legacy_library_into_null_safe

class StaffModel {
  String fullName;
  String addedBy;
  String? imagePath;

  StaffModel({
    required this.fullName,
    required this.addedBy,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'added_by': addedBy,
      'image_path': imagePath,
    };
  }

  factory StaffModel.fromSnapshot(Map<String, dynamic> data) {
    return StaffModel(
        fullName: data['full_name'] ?? ' ',
        addedBy: data['added_by'] ?? "",
        imagePath: data['image_path']);
  }
}
