import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/services/firebase/firebase_auth.dart';
import 'package:remote_eye/core/services/firebase/firebase_firestore_service.dart';
import 'package:remote_eye/features/login/models/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  FirebaseAuthService firebaseAuth = FirebaseAuthService();
  FirestoreService firestoreService = FirestoreService();

  Future<UserModel> getCurrentUserInfo() async {
    final user = firebaseAuth.getCurrentUser();
    UserModel userInfo = await firestoreService.getUserInfo(user?.uid);

    return userInfo;
  }
}
//  Future<void> getCurrentUser() async {
//     final user = firebaseAuth.getCurrentUser();
//     UserModel userInfo = await firestoreService.getUserInfo(user!);

//     userModel = userInfo;
//   }