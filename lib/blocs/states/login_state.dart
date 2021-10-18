part of '../login_bloc.dart';

enum LoginStatus {
  notLogin,
  success,
  notApproved,
}

class LoginState extends Equatable {
  const LoginState({
    this.phoneNumber = const LoginPhoneNumber.pure(),
    this.password = const PasswordLogin.pure(),
    this.loginStatus = LoginStatus.notLogin,
    this.status = FormzStatus.pure,
  });

  final LoginPhoneNumber phoneNumber;
  final PasswordLogin password;
  final LoginStatus loginStatus;
  final FormzStatus status;

  LoginState copyWith({
    LoginPhoneNumber? phoneNumber,
    PasswordLogin? password,
    LoginStatus? loginStatus,
    FormzStatus? status,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      loginStatus: loginStatus ?? this.loginStatus,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        password,
        loginStatus,
        status,
      ];
}
