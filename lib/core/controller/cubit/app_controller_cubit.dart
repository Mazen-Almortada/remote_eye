import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/services/database/database_provider.dart';
import 'package:remote_eye/core/services/database/hive/hive_strings.dart';
import 'package:remote_eye/core/services/firebase/firebase_auth.dart';

part 'app_controller_state.dart';

class AppControllerCubit extends Cubit<AppControllerState> {
  AppControllerCubit() : super(AppControllerInitial());
  DatabaseProvider database = DatabaseProvider();
  FirebaseAuthService firebaseAuth = FirebaseAuthService();

  Future<void> checkFirstTimeUse() async {
    final isFirstTime =
        database.getAt(settingsBox, isFirsTime) as bool? ?? true;

    if (isFirstTime) {
      emit(FirstTimeOpenApp());
    } else {
      bool isUserLoggedIn =
          firebaseAuth.getCurrentUser() == null ? false : true;
      if (isUserLoggedIn) {
        emit((NotFirstTime(isLoggedIn: true)));
      } else {
        emit((NotFirstTime(isLoggedIn: false)));
      }
    }
  }

  Future<void> setFirstTimeValue(bool value) async {
    database.putAt(value, settingsBox, isFirsTime);
  }
}
