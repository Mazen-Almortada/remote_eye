// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_controller_cubit.dart';

abstract class AppControllerState {
  const AppControllerState();
}

class AppControllerInitial extends AppControllerState {}

class FirstTimeOpenApp extends AppControllerState {}

class NotFirstTime extends AppControllerState {
  final bool isLoggedIn;
  NotFirstTime({
    required this.isLoggedIn,
  });
}
