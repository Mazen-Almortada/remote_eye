import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remote_eye/features/login/models/user_model.dart';
import 'package:remote_eye/features/staff/models/staff_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserInfo(String? uid) async {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").doc(uid).get();
    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);

    return userModel;
  }

  setUserInfo(UserModel userModel) async {
    await _firestore
        .collection("users")
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  setStaff(StaffModel staffModel, String staffName) async {
    await _firestore
        .collection("staffs")
        .doc(staffName)
        .set(staffModel.toMap());
  }

  deleteStaff(String staffName) async {
    await _firestore.collection("staffs").doc(staffName).delete();
  }

  deleteUser(String? userId) async {
    await _firestore.collection("users").doc(userId).delete();
  }

  Future<List<StaffModel>> getAllStaffs() async {
    // Get all documents from the collection
    final querySnapshot = await _firestore.collection("staffs").get();

    // Loop through the documents and map them to Staff objects
    List<StaffModel> staffList = querySnapshot.docs
        .map((doc) => StaffModel.fromSnapshot(doc.data()))
        .toList();

    return staffList;
  }

  Future<List<UserModel>> getAllUsers() async {
    final querySnapshot = await _firestore.collection("users").get();

    List<UserModel> usersList = querySnapshot.docs
        .map((doc) => UserModel.fromSnapshot(doc.data()))
        .toList();

    return usersList.where((user) => user.isSuperAdmin != true).toList();
  }
}
