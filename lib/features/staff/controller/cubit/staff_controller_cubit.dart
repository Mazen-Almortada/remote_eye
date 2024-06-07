import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/services/firebase/firebase_auth.dart';
import 'package:remote_eye/core/services/firebase/firebase_firestore_service.dart';
import 'package:remote_eye/core/services/firebase/firebase_storage_service.dart';
import 'package:remote_eye/features/staff/models/staff_model.dart';

part 'staff_controller_state.dart';

class StaffControllerCubit extends Cubit<StaffControllerState> {
  StaffControllerCubit() : super(StaffControllerInitial());
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  FirestoreService firestoreService = FirestoreService();
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  addStaff(String userName, File image) async {
    String errorMsg = 'Error uploading staff photo';
    try {
      final user = firebaseAuthService.getCurrentUser();
      final firstName = _getFirstName(userName);
      final imagePath =
          await firebaseStorageService.uploadStaffPicture(firstName, image);
      StaffModel staffModel = StaffModel(
          addedBy: user!.email!, fullName: userName, imagePath: imagePath);
      await firestoreService.setStaff(staffModel, firstName);
      emit(StaffUploadSuccess());
    } on PlatformException catch (e) {
      emit(StaffUploadError(errorMessage: e.message ?? errorMsg));
    } on FirebaseException catch (e) {
      emit(StaffUploadError(errorMessage: e.message ?? errorMsg));
    } catch (e) {
      emit(StaffUploadError(errorMessage: errorMsg));
    }
    fetchStaff();
  }

  void deleteStaff(StaffModel staffModel) async {
    try {
      String name = _getFirstName(staffModel.fullName);
      await firebaseStorageService.deleteImage(name);
      await firestoreService.deleteStaff(name);
    } on FirebaseException catch (e) {
      emit(DeleteStaffError(errorMessage: e.message ?? "Error deleting image"));
    } catch (_) {
      emit(DeleteStaffError(errorMessage: "Error deleting image"));
    }
    await fetchStaff();
  }

  Future<void> fetchStaff() async {
    String errorMsg = 'Error fetching staff list';
    emit(FetchStaffLoading());
    try {
      final staff = await firestoreService.getAllStaffs();
      if (staff.isEmpty) {
        emit(FetchStaffEmpty());
      } else {
        emit(FetchStaffSuccess(staffList: staff));
      }
    } on FirebaseException catch (e) {
      emit(FetchStaffError(errorMessage: e.message ?? errorMsg));
    } catch (_) {
      emit(FetchStaffError(errorMessage: errorMsg));
    }
  }

  String _getFirstName(String userName) {
    // Split the string into words
    List<String> words = userName.split(' ');

    // Return the first word
    if (words.isNotEmpty) {
      return words.first;
    } else {
      return ''; // Or handle the case when the string is empty
    }
  }
}
