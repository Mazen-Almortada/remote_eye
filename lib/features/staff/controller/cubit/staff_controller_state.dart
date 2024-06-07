// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'staff_controller_cubit.dart';

class StaffControllerState {}

class StaffControllerInitial extends StaffControllerState {}

class StaffUploadSuccess extends StaffControllerState {}

class FetchStaffSuccess extends StaffControllerState {
  final List<StaffModel> staffList;
  FetchStaffSuccess({
    required this.staffList,
  });
}

class FetchStaffError extends StaffControllerState {
  String errorMessage;
  FetchStaffError({
    required this.errorMessage,
  });
}

class FetchStaffEmpty extends StaffControllerState {}

class FetchStaffLoading extends StaffControllerState {}

class DeleteStaffError extends StaffControllerState {
  String errorMessage;
  DeleteStaffError({
    required this.errorMessage,
  });
}

class StaffUploadError extends StaffControllerState {
  String errorMessage;
  StaffUploadError({
    required this.errorMessage,
  });
}
