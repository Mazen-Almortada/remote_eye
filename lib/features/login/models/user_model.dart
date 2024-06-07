// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: import_of_legacy_library_into_null_safe

class UserModel {
  String? uid;
  String userName;
  String email;
  bool active;
  String password;
  String phoneNumber;
  bool isSuperAdmin;
  UserModel({
    this.uid,
    required this.userName,
    required this.email,
    this.active = true,
    required this.password,
    required this.phoneNumber,
    this.isSuperAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
      "isSuperAdmin": isSuperAdmin,
      'password': password,
      'phonenumber': phoneNumber,
      'active': active
    };
  }

  factory UserModel.fromSnapshot(dynamic snapshot) {
    return UserModel(
      uid: snapshot['uid'],
      userName: snapshot['userName'] ?? ' ',
      email: snapshot['email'] ?? "",
      isSuperAdmin: snapshot['isSuperAdmin'] ?? false,
      password: snapshot['password'] ?? "",
      phoneNumber: snapshot['phonenumber'] ?? "",
      active: snapshot['active'] ?? false,
    );
  }
}
