// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class NotLoggedIn extends AuthState {}

class LoginSuccess extends AuthState {}

class RestPasswordLinkSent extends AuthState {}

class RestPasswordLinkFailure extends AuthState {
  final String errorMessage;
  RestPasswordLinkFailure({
    required this.errorMessage,
  });
}

class LoginLoading extends AuthState {}

class FetchUsersLoading extends AuthState {}

class FetchUsersSuccess extends AuthState {
  List<UserModel> users;
  FetchUsersSuccess({
    required this.users,
  });
}

class FetchUsersFailure extends AuthState {
  String errorMessage;
  FetchUsersFailure({
    required this.errorMessage,
  });
}

class DeleteUserFailure extends AuthState {
  String errorMessage;
  DeleteUserFailure({
    required this.errorMessage,
  });
}

class CreateAccountSuccess extends AuthState {}

// class UpdateUserLoading extends AuthState {}

class UpdateUserFailure extends AuthState {
  final String errorMessage;

  UpdateUserFailure(this.errorMessage);
}

class UpdateUserSuccess extends AuthState {}

class CreateAccountError extends AuthState {
  final String errorMessage;

  CreateAccountError(this.errorMessage);
}

// class CreateAccountLoading extends AuthState {}

class LoginFailure extends AuthState {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}
