import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/services/firebase/firebase_auth.dart';
import 'package:remote_eye/core/services/firebase/firebase_firestore_service.dart';
import 'package:remote_eye/features/login/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  FirebaseAuthService firebaseAuth = FirebaseAuthService();
  FirestoreService firestoreService = FirestoreService();
  final String eMessage = "something error";
  login(String email, String password) async {
    emit(LoginLoading());
    try {
      await firebaseAuth.signIn(email, password);

      final user = firebaseAuth.getCurrentUser();
      UserModel userModel = await firestoreService.getUserInfo(user?.uid);
      if (userModel.password != password) {
        await firestoreService.setUserInfo(
          userModel..password = password,
        );
      }

      if (userModel.active == false) {
        emit(LoginFailure("your account is disabled"));
      } else {
        emit(LoginSuccess());
      }
    } on PlatformException catch (e) {
      emit(LoginFailure(e.message ?? eMessage));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? eMessage));
    } catch (e) {
      emit(LoginFailure(eMessage));
    }
  }

  signUp(UserModel userModel) async {
    try {
      await firebaseAuth
          .signUp(userModel.email, userModel.password)
          .then((user) async {
        await firestoreService.setUserInfo(userModel..uid = user?.user?.uid);
      });

      emit(CreateAccountSuccess());
    } on PlatformException catch (e) {
      emit(CreateAccountError(e.message ?? eMessage));
    } on FirebaseAuthException catch (e) {
      emit(CreateAccountError(e.message ?? eMessage));
    } on FirebaseException catch (e) {
      emit(CreateAccountError(e.message ?? eMessage));
    } catch (e) {
      emit(CreateAccountError(eMessage));
    }
  }

  updateUser(UserModel userModel, String newPassword) async {
    try {
      await firebaseAuth.updateUser(userModel, newPassword).then((user) async {
        userModel.password = newPassword;
        await firestoreService.setUserInfo(userModel);
      });

      emit(UpdateUserSuccess());
    } on PlatformException catch (e) {
      emit(UpdateUserFailure(e.message ?? eMessage));
    } on FirebaseAuthException catch (e) {
      emit(UpdateUserFailure(e.message ?? eMessage));
    } on FirebaseException catch (e) {
      emit(UpdateUserFailure(e.message ?? eMessage));
    } catch (e) {
      emit(UpdateUserFailure(eMessage));
    }
  }

  sendRestPasswordLink(String email) async {
    try {
      await firebaseAuth.sendRestPasswordLink(email);
      emit(RestPasswordLinkSent());
    } on PlatformException catch (e) {
      emit(RestPasswordLinkFailure(errorMessage: e.message ?? eMessage));
    } on FirebaseException catch (e) {
      emit(RestPasswordLinkFailure(errorMessage: e.message ?? eMessage));
    } catch (e) {
      emit(RestPasswordLinkFailure(errorMessage: eMessage));
    }
  }

  fetchUsers() async {
    emit(FetchUsersLoading());
    try {
      final usersList = await firestoreService.getAllUsers();

      if (usersList.isEmpty) {
        emit(FetchUsersFailure(errorMessage: "empty"));
      } else {
        emit(FetchUsersSuccess(users: usersList));
      }
    } on PlatformException catch (e) {
      emit(FetchUsersFailure(errorMessage: e.message ?? eMessage));
    } on FirebaseException catch (e) {
      emit(FetchUsersFailure(errorMessage: e.message ?? eMessage));
    } catch (e) {
      emit(FetchUsersFailure(errorMessage: eMessage));
    }
  }

  void deleteUser(UserModel userModel) async {
    try {
      await firebaseAuth.deleteUser(userModel.email, userModel.password);
      await firestoreService.deleteUser(userModel.uid);
    } on FirebaseException catch (e) {
      emit(DeleteUserFailure(errorMessage: e.message ?? "Error deleting user"));
    } catch (_) {
      emit(DeleteUserFailure(errorMessage: "Error deleting user"));
    }
    await fetchUsers();
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
